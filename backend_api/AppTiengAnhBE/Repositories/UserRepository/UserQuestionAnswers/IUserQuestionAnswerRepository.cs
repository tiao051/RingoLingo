using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;

namespace AppTiengAnhBE.Repositories.UserRepository.UserQuestionAnswers
{
    public interface IUserQuestionAnswerRepository
    {
        Task<IEnumerable<UserAnswerDetail>> GetUserAnswerDetailsByResultIdAsync(int userResultId);
        Task<IEnumerable<UserAnswerDetail>> GetWrongQuestionDetails(int userResultId);
    }
}
