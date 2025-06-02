namespace AppTiengAnhBE.Models.DTOs.LessonDTO
{
    public class SubmitRequest
    {
        public int UserId { get; set; }
        public int LessonId { get; set; }
        public DateTime StartedAt { get; set; }
        public required List<AnswerRequest> Answers { get; set; }
    }
}
