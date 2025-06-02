using Dapper;
using System.Data;
using AppTiengAnhBE.Models.SystemModel;

namespace AppTiengAnhBE.Repositories.CategoryServices.CategoriesCRUDRepo
{
    public class CategoryRepository : ICategoryRepository
    {
        private readonly IDbConnection _db;

        public CategoryRepository(IDbConnection db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Category>> GetAllCategoriesAsync()
        {
            var sql = "SELECT * FROM categories ORDER BY id";
            return await _db.QueryAsync<Category>(sql);
        }

        public async Task<Category> GetCategoryByIdAsync(int id)
        {
            var sql = "SELECT * FROM categories WHERE id = @id";
            return await _db.QueryFirstOrDefaultAsync<Category>(sql, new { id });
        }

        public async Task<int> CreateCategoryAsync(Category category)
        {
            var sql = "INSERT INTO categories (name, description, created_at) VALUES (@name, @description, @created_at) RETURNING id;";
            return await _db.ExecuteScalarAsync<int>(sql, new
            {
                category.name,
                category.description,
                category.created_at
            });
        }

        public async Task<int> UpdateCategoryAsync(Category category)
        {
            var sql = "UPDATE categories SET name = @name, description = @description WHERE id = @id;";
            return await _db.ExecuteAsync(sql, new
            {
                category.id,
                category.name,
                category.description
            });
        }

        public async Task<int> DeleteCategoryAsync(int id)
        {
            var sql = "DELETE FROM categories WHERE id = @id;";
            return await _db.ExecuteAsync(sql, new { id });
        }
    }
}
