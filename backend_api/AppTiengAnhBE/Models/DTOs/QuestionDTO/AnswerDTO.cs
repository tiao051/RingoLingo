namespace AppTiengAnhBE.Models.DTOs.QuestionDTO
{
    public class AnswerDTO
    {
        public int Id { get; set; }
        public int QuestionId { get; set; }
        public required string AnswerText { get; set; }
        public bool IsCorrect { get; set; }
    }
}
