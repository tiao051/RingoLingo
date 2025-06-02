namespace AppTiengAnhBE.Models.DTOs.UserLessonResultDTO
{
    public class UserLessonResult
    {
        public int Id { get; set; }             
        public int UserId { get; set; }
        public int LessonId { get; set; }
        public int Score { get; set; }      
        public DateTime CreatedAt { get; set; }
    }
}
