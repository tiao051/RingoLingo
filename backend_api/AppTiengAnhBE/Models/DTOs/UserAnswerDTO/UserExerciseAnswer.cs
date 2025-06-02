namespace AppTiengAnhBE.Models.DTOs.UserAnswerDTO
{
    public class UserExerciseAnswer
    {
        public int Id { get; set; }
        public int UserResultId { get; set; }
        public int QuestionId { get; set; }
        public string AnswerText { get; set; }
        public bool IsCorrect { get; set; }
        public DateTime AnsweredAt { get; set; }
    }

}
