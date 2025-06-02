using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;
using AppTiengAnhBE.Repositories.UserRepository.UserQuestionAnswers;

namespace AppTiengAnhBE.Services.UserServices.UserQuestionAnswers
{
    public class UserQuestionAnswerService : IUserQuestionAnswerService
    {
        private readonly IUserQuestionAnswerRepository _repository;

        public UserQuestionAnswerService(IUserQuestionAnswerRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<UserAnswerDetail>> GetUserAnswerDetailsAsync(int userResultId)
        {
            return await _repository.GetUserAnswerDetailsByResultIdAsync(userResultId);
        }
        public async Task<IEnumerable<UserAnswerDetail>> GetWrongQuestionIds(int userResultId)
        {
            return await _repository.GetWrongQuestionDetails(userResultId);
        }
    }
}
