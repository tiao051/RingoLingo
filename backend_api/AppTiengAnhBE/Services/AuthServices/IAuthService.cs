using AppTiengAnhBE.Models.DTOs.LoginDTO;
using AppTiengAnhBE.Models.DTOs.SignUpDTO;

namespace AppTiengAnhBE.Services.AuthServices
{
    public interface IAuthService
    {
        Task<LoginResponse> LoginAsync(Models.DTOs.LoginDTO.LoginRequest request);
        Task<RefreshTokenResponse> RefreshAccessTokenAsync(RefreshTokenRequest request);
        Task RegisterAsync(SignUpRequest request);
    }
}
