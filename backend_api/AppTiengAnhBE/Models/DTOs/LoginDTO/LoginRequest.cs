namespace AppTiengAnhBE.Models.DTOs.LoginDTO
{
    public class LoginRequest
    {
        public required string Email { get; set; }
        public required string Password { get; set; }
    }
}
