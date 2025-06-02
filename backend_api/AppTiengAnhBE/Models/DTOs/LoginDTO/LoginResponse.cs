namespace AppTiengAnhBE.Models.DTOs.LoginDTO
{
    public class LoginResponse
    {
        public required string Token { get; set; }
        public required string Username { get; set; }
        public string RefreshToken { get; set; }
    }
}
