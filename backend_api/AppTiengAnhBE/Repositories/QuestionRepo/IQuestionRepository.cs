using AppTiengAnhBE.Models.DTOs.QuestionDTO;

namespace AppTiengAnhBE.Repositories.QuestionRepo
{
    public interface IQuestionRepository
    {
        Task<IEnumerable<QuestionDTO>> GetQuestionsByLessonAsync(int lessonId);
        Task<IEnumerable<QuestionDTO>> GetWrongQuestionsWithAnswersAsync(int userResultId);
    }
}
