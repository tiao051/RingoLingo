namespace AppTiengAnhBE.Models.DTOs.ReminderDTO
{
    public class ReminderDTO
    {
        public string Email { get; set; }
        public TimeSpan TimeToRemind { get; set; }
    }
}
