using Dapper;
using System.Data;
using AppTiengAnhBE.Models.SystemModel;

namespace AppTiengAnhBE.Repositories.UserRepository.UserCRUDRepo
{
    public class UserRepository : IUserRepository
    {
        private readonly IDbConnection _db;

        public UserRepository(IDbConnection dbConnection)
        {
            _db = dbConnection;
        }

        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            const string sql = "SELECT * FROM users";
            return await _db.QueryAsync<User>(sql);
        }

        public async Task<User?> GetUserByIdAsync(int id)
        {
            const string sql = "SELECT * FROM users WHERE id = @Id";
            return await _db.QueryFirstOrDefaultAsync<User>(sql, new { Id = id });
        }

        public async Task CreateUserAsync(User user)
        {
            var query = @"INSERT INTO users (username, email, password, role_id)
                      VALUES (@Username, @Email, @Password, @role_id)";
            await _db.ExecuteAsync(query, user);
        }

        public async Task<int> UpdateUserAsync(User user)
        {
            const string sql = @"
                UPDATE users 
                SET 
                    username = @Username,
                    full_name = @Full_Name,
                    email = @Email, 
                    password = @Password,
                    role_id = @Role_Id
                WHERE id = @Id";

            return await _db.ExecuteAsync(sql, new
            {
                user.username,
                user.full_name,
                user.email,
                user.password,
                user.role_id,
                user.id
            });
        }

        public async Task<int> DeleteUserAsync(int id)
        {
            const string sql = "DELETE FROM users WHERE id = @Id";
            return await _db.ExecuteAsync(sql, new { Id = id });
        }

        public async Task<User?> GetUserByEmailAsync(string email)
        {
            const string sql = "SELECT id, email, password AS Password, username FROM users WHERE email = @Email";
            return await _db.QueryFirstOrDefaultAsync<User>(sql, new { Email = email });
        }
    }
}
