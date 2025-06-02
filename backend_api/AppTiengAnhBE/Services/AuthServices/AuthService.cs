using Microsoft.Extensions.Options;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using AppTiengAnhBE.Domain.Entities;
using AppTiengAnhBE.Repositories.UserRepository.UserCRUDRepo;
using AppTiengAnhBE.Models.DTOs.LoginDTO;
using AppTiengAnhBE.Models.SystemModel;
using AppTiengAnhBE.Services.AuthServices;
using AppTiengAnhBE.Models.DTOs.SignUpDTO;

public class AuthService : IAuthService
{
    private readonly IUserRepository _userRepo;
    private readonly JwtSettings _jwtSettings;

    public AuthService(IUserRepository userRepo, IOptions<JwtSettings> jwtOptions)
    {
        _userRepo = userRepo;
        _jwtSettings = jwtOptions.Value;
    }

    public async Task<LoginResponse> LoginAsync(LoginRequest request)
    {
        var user = await _userRepo.GetUserByEmailAsync(request.Email);
        if (user == null || request.Password != user.password)
            throw new UnauthorizedAccessException("Invalid email or password");

        var accessToken = GenerateJwt(user);
        var refreshToken = GenerateRefreshToken(user);

        return new LoginResponse
        {
            Token = accessToken,
            RefreshToken = refreshToken,
            Username = user.username
        };
    }

    public string GenerateJwt(User user)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.email),
            new Claim("userId", user.id.ToString()), 
            new Claim("username", user.username),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(_jwtSettings.ExpireMinutes),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public string GenerateRefreshToken(User user)
    {
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.RefreshSecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.email),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddDays(_jwtSettings.RefreshExpireDays),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    public async Task<RefreshTokenResponse> RefreshAccessTokenAsync(RefreshTokenRequest request)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_jwtSettings.RefreshSecretKey);

        try
        {
            var principal = tokenHandler.ValidateToken(request.RefreshToken, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = true,
                ValidIssuer = _jwtSettings.Issuer,
                ValidateAudience = true,
                ValidAudience = _jwtSettings.Audience,
                ValidateLifetime = true,
                ClockSkew = TimeSpan.Zero
            }, out SecurityToken validatedToken);

            var userEmail = principal.FindFirstValue(JwtRegisteredClaimNames.Sub);
            if (userEmail == null)
                throw new SecurityTokenException("Invalid token");

            var user = await _userRepo.GetUserByEmailAsync(userEmail);
            if (user == null)
                throw new SecurityTokenException("Invalid token");

            var newAccessToken = GenerateJwt(user);

            return new RefreshTokenResponse { Token = newAccessToken };
        }
        catch (Exception)
        {
            throw new SecurityTokenException("Invalid refresh token");
        }
    }
    public async Task RegisterAsync(SignUpRequest request)
    {
        var existingUser = await _userRepo.GetUserByEmailAsync(request.Email);
        if (existingUser != null)
            throw new Exception("Email already registered");

        var newUser = new User
        {
            username = request.Username,
            email = request.Email,
            password = request.Password,
            role_id = 2
        };

        await _userRepo.CreateUserAsync(newUser);
    }
}
