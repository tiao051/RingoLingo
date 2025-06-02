using AppTiengAnhBE.Models.DTOs.QuestionDTO;
using AppTiengAnhBE.Models.SystemModel;
using AppTiengAnhBE.Repositories.QuestionRepo;

namespace AppTiengAnhBE.Services.QuestionServices
{
    public class QuestionService : IQuestionService
    {
        private readonly IQuestionRepository _repo;

        public QuestionService(IQuestionRepository repo)
        {
            _repo = repo;
        }

        public async Task<IEnumerable<QuestionDTO>> GetQuestionsByLessonAsync(int lessonId)
        {
            return await _repo.GetQuestionsByLessonAsync(lessonId);
        }

        public async Task<IEnumerable<QuestionDTO>> GetWrongQuestionsWithAnswersAsync(int userResultId)
        {
            return await _repo.GetWrongQuestionsWithAnswersAsync(userResultId);
        }
    }
}
