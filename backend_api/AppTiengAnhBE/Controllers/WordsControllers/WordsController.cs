using AppTiengAnhBE.Services.WordServices;
using Microsoft.AspNetCore.Mvc;

namespace AppTiengAnhBE.Controllers.WordsControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WordsController : ControllerBase
    {
        private readonly IWordService _service;

        public WordsController(IWordService service)
        {
            _service = service;
        }

        [HttpGet("filter")]
        public async Task<IActionResult> GetByCategoryAndLesson([FromQuery] int categoryId, [FromQuery] int lessonId)
        {
            var result = await _service.GetWordsByCategoryAndLessonAsync(categoryId, lessonId);
            return Ok(result);
        }
    }
}
