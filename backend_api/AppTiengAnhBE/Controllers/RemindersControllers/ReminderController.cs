using AppTiengAnhBE.Models;
using AppTiengAnhBE.Services.RemindersCRUDServices;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AppTiengAnhBE.Controllers.RemindersControllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReminderController : ControllerBase
    {
        private readonly IReminderService _reminderService;
        public ReminderController(IReminderService reminderService)
        {
            _reminderService = reminderService;
        }

        // POST: api/reminders
        [HttpPost]
        public async Task<IActionResult> CreateReminder([FromBody] Reminder reminder)
        {
            Console.WriteLine($"userId:{reminder.UserId}");
            Console.WriteLine($"CategoryId: {reminder.CategoryId}, LessonId: {reminder.LessonId}");

            if ((reminder.CategoryId == null && reminder.LessonId == null) ||
                (reminder.CategoryId != null && reminder.LessonId != null))
            {
                return BadRequest("Controller: Chỉ được chọn 1 trong 2: category_id hoặc lesson_id");
            }

            var id = await _reminderService.CreateReminder(reminder);
            return Ok(new { id });
        }

        // GET: api/reminders?userId=xxx
        [HttpGet]
        public async Task<IActionResult> GetReminders([FromQuery] int userId)
        {
            var reminders = await _reminderService.GetRemindersByUser(userId);
            return Ok(reminders);
        }

        // PUT: api/reminders/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateReminder(int id, [FromBody] Reminder reminder)
        {
            if (id != reminder.Id) return BadRequest();
            var success = await _reminderService.UpdateReminder(reminder);
            if (!success) return NotFound();
            return NoContent();
        }

        // DELETE: api/reminders/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteReminder(int id)
        {
            var success = await _reminderService.DeleteReminder(id);
            if (!success) return NotFound();
            return NoContent();
        }

        // GET: api/reminders/trigger?now=08:00:00
        [HttpGet("trigger")]
        public async Task<IActionResult> TriggerReminders([FromQuery] TimeSpan now)
        {
            var reminders = await _reminderService.GetRemindersToTrigger(now);
            return Ok(reminders);
        }
    }
}
