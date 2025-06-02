namespace AppTiengAnhBE.Models.DTOs.UserAnswerDTO
{
    public class UserAnswerDetail
    {
        public int QuestionId { get; set; }
        public required string QuestionContent { get; set; }
        public required string CorrectAnswerText { get; set; }
        public required string UserAnswerText { get; set; }
        public bool UserIsCorrect { get; set; }
    }
}
