using AppTiengAnhBE.Models.DTOs.SignUpDTO;
using AppTiengAnhBE.Services.AuthServices;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AppTiengAnhBE.Controllers.AccountControlles
{
    [Route("api/[controller]")]
    [ApiController]
    public class SignUpController : ControllerBase
    {
        private readonly IAuthService _authService;

        public SignUpController(IAuthService authService)
        {
            _authService = authService;
        }
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] SignUpRequest request)
        {
            try
            {
                await _authService.RegisterAsync(request);
                return Ok(new { message = "User registered successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
