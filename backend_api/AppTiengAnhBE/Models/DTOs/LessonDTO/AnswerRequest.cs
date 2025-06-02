namespace AppTiengAnhBE.Models.DTOs.LessonDTO
{
    public class AnswerRequest
    {
        public int QuestionId { get; set; }
        public required string AnswerText { get; set; }
    }
}
