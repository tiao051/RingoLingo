using AppTiengAnhBE.Domain.Entities;
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

        public async Task<Lesson> GetLessonByIdAsync(int id)
        {
            var sql = "SELECT id, category_id, title, description, order_num, created_at FROM lessons WHERE id = @Id";
            return await _db.QueryFirstOrDefaultAsync<Lesson>(sql, new { Id = id });
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
