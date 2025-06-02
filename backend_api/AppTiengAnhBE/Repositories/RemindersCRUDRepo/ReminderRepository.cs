using AppTiengAnhBE.Models;
using Dapper;
using System.Data;

namespace AppTiengAnhBE.Repositories.RemindersCRUDRepo
{
    public class ReminderRepository : IReminderRepository
    {
        private readonly IDbConnection _db;
        public ReminderRepository(IDbConnection db)
        {
            _db = db;
        }

        public async Task<int> CreateReminder(Reminder reminder)
        {
            var sql = @"INSERT INTO reminders (user_id, category_id, lesson_id, reminder_time, mode, is_active)
                        VALUES (@UserId, @CategoryId, @LessonId, @ReminderTime, @Mode, @IsActive)
                        RETURNING id;";
            return await _db.ExecuteScalarAsync<int>(sql, reminder);
        }

        public async Task<IEnumerable<Reminder>> GetRemindersByUser(int userId)
        {
            var sql = "SELECT * FROM reminders WHERE user_id = @UserId ORDER BY created_at DESC;";
            return await _db.QueryAsync<Reminder>(sql, new { UserId = userId });
        }

        public async Task<Reminder?> GetReminderById(int id)
        {
            var sql = "SELECT * FROM reminders WHERE id = @Id;";
            return await _db.QueryFirstOrDefaultAsync<Reminder>(sql, new { Id = id });
        }

        public async Task<bool> UpdateReminder(Reminder reminder)
        {
            var sql = @"UPDATE reminders SET category_id = @CategoryId, lesson_id = @LessonId, reminder_time = @ReminderTime, mode = @Mode, is_active = @IsActive, updated_at = NOW() WHERE id = @Id;";
            var result = await _db.ExecuteAsync(sql, reminder);
            return result > 0;
        }

        public async Task<bool> DeleteReminder(int id)
        {
            var sql = "DELETE FROM reminders WHERE id = @Id;";
            var result = await _db.ExecuteAsync(sql, new { Id = id });
            return result > 0;
        }

        public async Task<IEnumerable<Reminder>> GetRemindersToTrigger(TimeSpan now)
        {
            var sql = @"SELECT * FROM reminders WHERE is_active = TRUE AND reminder_time = @Now;";
            return await _db.QueryAsync<Reminder>(sql, new { Now = now });
        }
    }
}
