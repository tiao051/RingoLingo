using AppTiengAnhBE.Models.DTOs.LessonDTO;
using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;
using AppTiengAnhBE.Models.DTOs.UserLessonResultDTO;

namespace AppTiengAnhBE.Services.LessonServices.LessonResults
{
    public interface ILessonResultService
    {
        Task<SubmitResult> ProcessSubmissionAsync(SubmitRequest request);
        Task<IEnumerable<UserExerciseAnswer>> GetAnswersByResultIdAsync(int resultId);
        Task<IEnumerable<UserLessonResult>> GetLessonResultsByUserIdAsync(int userId);
    }
}
