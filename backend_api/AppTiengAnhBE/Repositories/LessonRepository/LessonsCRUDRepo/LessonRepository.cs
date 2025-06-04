using AppTiengAnhBE.Domain.Entities;
using AppTiengAnhBE.Models.SystemModel;
using Dapper;
using System.Data;

namespace AppTiengAnhBE.Repositories.LessonRepository.LessonsCRUDRepo
{
    public class LessonRepository : ILessonRepository
    {
        private readonly IDbConnection _db;

        public LessonRepository(IDbConnection db)
        {
            _db = db;
        }

        public async Task<IEnumerable<Lesson>> GetAllLessonsAsync()
        {
            var sql = "SELECT id, category_id, title, description, order_num, created_at FROM lessons ORDER BY order_num";
            return await _db.QueryAsync<Lesson>(sql);
        }

        public async Task<IEnumerable<Lesson>> GetLessonsByCategoryIdAsync(int categoryId)
        {
            var sql = "SELECT id, category_id, title, description, order_num, created_at FROM lessons WHERE category_id = @CategoryId";
            return await _db.QueryAsync<Lesson>(sql, new { CategoryId = categoryId });
        }

        public async Task<int> CreateLessonAsync(Lesson lesson)
        {
            var sql = @"
                INSERT INTO lessons (category_id, title, description, order_num, created_at)
                VALUES (@CategoryId, @Title, @Description, @OrderNum, @CreatedAt)
                RETURNING id;";

            return await _db.ExecuteScalarAsync<int>(sql, lesson);
        }

        public async Task<int> UpdateLessonAsync(Lesson lesson)
        {
            var sql = @"UPDATE lessons 
                        SET category_id = @CategoryId, 
                            title = @Title, 
                            description = @Description, 
                            order_num = @OrderNum 
                        WHERE id = @Id;";
            return await _db.ExecuteAsync(sql, lesson);
        }

        public async Task<int> DeleteLessonAsync(int lessonId)
        {
            var sql = "DELETE FROM lessons WHERE id = @Id;";
            return await _db.ExecuteAsync(sql, new { Id = lessonId });
        }
    }
}
