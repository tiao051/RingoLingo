using AppTiengAnhBE.Models.DTOs.LessonDTO;
using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;
using AppTiengAnhBE.Models.DTOs.UserLessonResultDTO;
using AppTiengAnhBE.Repositories.LessonRepository.LessonResults;

namespace AppTiengAnhBE.Services.LessonServices.LessonResults
{
    public class LessonResultService : ILessonResultService
    {
        private readonly ILessonResultRepository _repo;

        public LessonResultService(ILessonResultRepository repo)
        {
            _repo = repo;
        }
        public async Task<SubmitResult> ProcessSubmissionAsync(SubmitRequest request)
        {
            int totalCorrect = 0;
            int totalQuestions = request.Answers.Count;

            var correctness = new List<(int QuestionId, string AnswerText, bool IsCorrect)>();

            foreach (var ans in request.Answers)
            {
                var correctAnswers = await _repo.GetCorrectAnswersAsync(ans.QuestionId);
                bool isCorrect = correctAnswers.Contains(ans.AnswerText.Trim().ToLower());
                if (isCorrect) totalCorrect++;

                correctness.Add((ans.QuestionId, ans.AnswerText, isCorrect));
            }

            float score = totalQuestions == 0 ? 0 : (float)totalCorrect / totalQuestions * 10;

            var vietnamTimeZone = TimeZoneInfo.FindSystemTimeZoneById("SE Asia Standard Time");
            DateTime startedAtVN = TimeZoneInfo.ConvertTime(request.StartedAt, vietnamTimeZone);
            DateTime nowVN = TimeZoneInfo.ConvertTime(DateTime.Now, vietnamTimeZone);

            Console.WriteLine($"DateTime.Now: {DateTime.Now}");
            Console.WriteLine($"DateTime.UtcNow: {DateTime.UtcNow}");
            Console.WriteLine($"TimeZoneInfo.Local.Id: {TimeZoneInfo.Local.Id}");

            int resultId = await _repo. CreateUserLessonResultAsync(
                request.UserId, request.LessonId, totalQuestions, totalCorrect, score, startedAtVN, nowVN);

            foreach (var item in correctness)
            {
                await _repo.SaveUserAnswerAsync(resultId, item.QuestionId, item.AnswerText, item.IsCorrect);
            }

            var duration = nowVN - startedAtVN;
            if (duration.TotalSeconds < 0)
                duration = TimeSpan.Zero;

            string durationText = FormatDuration(duration);

            return new SubmitResult
            {
                TotalQuestions = totalQuestions,
                TotalCorrect = totalCorrect,
                Score = score,
                DurationText = durationText
            };
        }

        private string FormatDuration(TimeSpan duration)
        {
            if (duration.TotalSeconds < 60)
                return $"{duration.Seconds} giây";
            else
                return $"{(int)duration.TotalMinutes} phút {duration.Seconds % 60} giây";
        }

        public async Task<IEnumerable<UserExerciseAnswer>> GetAnswersByResultIdAsync(int resultId)
        {
            return await _repo.GetUserAnswersByResultIdAsync(resultId);
        }
        public async Task<IEnumerable<UserLessonResult>> GetLessonResultsByUserIdAsync(int userId)
        {
            return await _repo.GetLessonResultsByUserIdAsync(userId);
        }
    }
}
