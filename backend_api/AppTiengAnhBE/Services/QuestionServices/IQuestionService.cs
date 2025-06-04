using AppTiengAnhBE.Models.DTOs.QuestionDTO;

namespace AppTiengAnhBE.Services.QuestionServices
{
    public interface IQuestionService
    {
        Task<IEnumerable<QuestionDTO>> GetQuestionsByLessonAsync(int lessonId);
        Task<IEnumerable<QuestionDTO>> GetWrongQuestionsWithAnswersAsync(int userResultId);
        Task<IEnumerable<QuestionDTO>> GetQuestionsForLisTestByLessonAsync(int lessonId);
    }
}
