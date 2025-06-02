using AppTiengAnhBE.Models.SystemModel;

namespace AppTiengAnhBE.Repositories.UserRepository.UserCRUDRepo
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> GetAllUsersAsync();
        Task<User> GetUserByIdAsync(int id);
        Task CreateUserAsync(User user);
        Task<int> UpdateUserAsync(User user);
        Task<int> DeleteUserAsync(int id);
        Task<User?> GetUserByEmailAsync(string email);
    }
}
