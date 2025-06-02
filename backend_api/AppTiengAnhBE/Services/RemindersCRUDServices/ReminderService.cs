using AppTiengAnhBE.Models;
using AppTiengAnhBE.Repositories.RemindersCRUDRepo;

namespace AppTiengAnhBE.Services.RemindersCRUDServices
{
    public interface IReminderService
    {
        Task<int> CreateReminder(Reminder reminder);
        Task<IEnumerable<Reminder>> GetRemindersByUser(int userId);
        Task<Reminder?> GetReminderById(int id);
        Task<bool> UpdateReminder(Reminder reminder);
        Task<bool> DeleteReminder(int id);
        Task<IEnumerable<Reminder>> GetRemindersToTrigger(TimeSpan now);
    }

    public class ReminderService : IReminderService
    {
        private readonly IReminderRepository _reminderRepository;

        public ReminderService(IReminderRepository reminderRepository)
        {
            _reminderRepository = reminderRepository;
        }

        public async Task<int> CreateReminder(Reminder reminder)
        {
            return await _reminderRepository.CreateReminder(reminder);
        }

        public async Task<IEnumerable<Reminder>> GetRemindersByUser(int userId)
        {
            return await _reminderRepository.GetRemindersByUser(userId);
        }

        public async Task<Reminder?> GetReminderById(int id)
        {
            return await _reminderRepository.GetReminderById(id);
        }

        public async Task<bool> UpdateReminder(Reminder reminder)
        {
            return await _reminderRepository.UpdateReminder(reminder);
        }

        public async Task<bool> DeleteReminder(int id)
        {
            return await _reminderRepository.DeleteReminder(id);
        }

        public async Task<IEnumerable<Reminder>> GetRemindersToTrigger(TimeSpan now)
        {
            return await _reminderRepository.GetRemindersToTrigger(now);
        }
    }
}
