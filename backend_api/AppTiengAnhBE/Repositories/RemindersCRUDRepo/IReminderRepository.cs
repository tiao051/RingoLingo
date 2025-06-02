using AppTiengAnhBE.Models;

namespace AppTiengAnhBE.Repositories.RemindersCRUDRepo
{
    public interface IReminderRepository
    {
        Task<int> CreateReminder(Reminder reminder);
        Task<IEnumerable<Reminder>> GetRemindersByUser(int userId);
        Task<Reminder?> GetReminderById(int id);
        Task<bool> UpdateReminder(Reminder reminder);
        Task<bool> DeleteReminder(int id);
        Task<IEnumerable<Reminder>> GetRemindersToTrigger(TimeSpan now);
    }
}
