using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;

namespace AppTiengAnhBE.Services.UserServices.UserQuestionAnswers
{
    public interface IUserQuestionAnswerService
    {
        Task<IEnumerable<UserAnswerDetail>> GetUserAnswerDetailsAsync(int userResultId);
        Task<IEnumerable<UserAnswerDetail>> GetWrongQuestionIds(int userResultId);
    }
}
