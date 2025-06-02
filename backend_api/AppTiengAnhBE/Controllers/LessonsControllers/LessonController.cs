using AppTiengAnhBE.Domain.Entities;
using AppTiengAnhBE.Services.LessonServices.LessonsCRUDServices;
using Microsoft.AspNetCore.Mvc;

namespace AppTiengAnhBE.Controllers.LessonsControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LessonController : ControllerBase
    {
        private readonly ILessonService _lessonService;

        public LessonController(ILessonService lessonService)
        {
            _lessonService = lessonService;
        }

        [HttpGet("lessons")]
        public async Task<IActionResult> GetLessons()
        {
            var lessons = await _lessonService.GetAllLessonsAsync();
            return Ok(lessons);
        }

        [HttpGet("lessons/{id}")]
        public async Task<IActionResult> GetLessonById(int id)
        {
            var lesson = await _lessonService.GetLessonByIdAsync(id);
            if (lesson == null) return NotFound();
            return Ok(lesson);
        }

        [HttpPost("lessons")]
        public async Task<IActionResult> CreateLesson([FromBody] Lesson lesson)
        {
            var id = await _lessonService.CreateLessonAsync(lesson);
            return CreatedAtAction(nameof(GetLessonById), new { id }, lesson);
        }

        [HttpPut("lessons/{id}")]
        public async Task<IActionResult> UpdateLesson(int id, [FromBody] Lesson lesson)
        {
            lesson.id = id;
            var result = await _lessonService.UpdateLessonAsync(lesson);
            if (result == 0) return NotFound();
            return NoContent();
        }

        [HttpDelete("lessons/{id}")]
        public async Task<IActionResult> DeleteLesson(int id)
        {
            var result = await _lessonService.DeleteLessonAsync(id);
            if (result == 0) return NotFound();
            return NoContent();
        }
    }
}
