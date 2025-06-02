using AppTiengAnhBE.Models.DTOs.QuestionDTO;
using AppTiengAnhBE.Services.QuestionServices;
using Microsoft.AspNetCore.Mvc;

namespace AppTiengAnhBE.Controllers.QuestionsControllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionController : ControllerBase
    {
        private readonly IQuestionService _questionService;

        public QuestionController(IQuestionService questionService)
        {
            _questionService = questionService;
        }

        [HttpGet("question-by-lesson/{lessonId}")]
        public async Task<IActionResult> GetQuestionsByLesson(int lessonId)
        {
            var questions = await _questionService.GetQuestionsByLessonAsync(lessonId);
            return Ok(questions);
        }

        //test: https://localhost:7093/api/question/question-by-lesson/25/wrong-questions

        [HttpGet("question-by-lesson/{userResultId}/wrong-questions")]
        public async Task<ActionResult<IEnumerable<QuestionDTO>>> GetWrongQuestionsRetry(int userResultId)
        {
            if (userResultId <= 0)
                return BadRequest("Invalid userResultId");

            var wrongQuestions = await _questionService.GetWrongQuestionsWithAnswersAsync(userResultId);

            if (wrongQuestions == null || !wrongQuestions.Any())
                return NotFound("No wrong questions found for this user result.");

            return Ok(wrongQuestions);
        }
    }
}
