namespace AppTiengAnhBE.Models.DTOs.QuestionDTO
{
    public class QuestionDTO
    {
        public int Id { get; set; }
        public required string QuestionText { get; set; }
        public required string TypeName { get; set; }
        public required List<AnswerDTO> AnswersText { get; set; }
    }
}
