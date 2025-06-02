using AppTiengAnhBE.Models.SystemModel;

namespace AppTiengAnhBE.Services.UserServices.UserCRUDServices
{
    public interface IUserService
    {
        Task<IEnumerable<User>> GetAllUsersAsync();
        Task<User> GetUserByIdAsync(int id);
        Task<int> UpdateUserAsync(User user);
        Task<int> DeleteUserAsync(int id);
    }
}
