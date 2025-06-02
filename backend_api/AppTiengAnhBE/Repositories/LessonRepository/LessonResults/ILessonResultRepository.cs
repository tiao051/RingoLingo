using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;
using AppTiengAnhBE.Models.DTOs.UserLessonResultDTO;

namespace AppTiengAnhBE.Repositories.LessonRepository.LessonResults
{
    public interface ILessonResultRepository
    {
        Task<int> CreateUserLessonResultAsync(
            int userId,
            int lessonId,
            int totalQuestions,
            int totalCorrect,
            float score,
            DateTime startedAt,
            DateTime submittedAt);
        Task SaveUserAnswerAsync(int resultId, int questionId, string answerText, bool isCorrect);
        Task<List<string>> GetCorrectAnswersAsync(int questionId);
        Task<IEnumerable<UserExerciseAnswer>> GetUserAnswersByResultIdAsync(int resultId);
        Task<IEnumerable<UserLessonResult>> GetLessonResultsByUserIdAsync(int userId);
    }
}