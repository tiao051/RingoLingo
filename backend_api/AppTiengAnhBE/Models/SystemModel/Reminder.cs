using System.Text.Json.Serialization;

public class Reminder
{
    public int Id { get; set; }

    [JsonPropertyName("user_id")]
    public int UserId { get; set; }

    [JsonPropertyName("category_id")]
    public int? CategoryId { get; set; }

    [JsonPropertyName("lesson_id")]
    public int? LessonId { get; set; }

    [JsonPropertyName("reminder_time")]
    public TimeSpan ReminderTime { get; set; }

    public string Mode { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
