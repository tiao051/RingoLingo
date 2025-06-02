using AppTiengAnhBE.Models.DTOs.UserAnswerDTO;
using AppTiengAnhBE.Models.DTOs.UserLessonResultDTO;
using Dapper;
using System;
using System.Data;

namespace AppTiengAnhBE.Repositories.LessonRepository.LessonResults
{
    public class LessonResultRepository : ILessonResultRepository
    {
        private readonly IDbConnection _dbConnection;
        public LessonResultRepository(IDbConnection dbConnection)
        {
            _dbConnection = dbConnection;
        }
        public async Task<int> CreateUserLessonResultAsync(
            int userId,
            int lessonId,
            int totalQuestions,
            int totalCorrect,
            float score,
            DateTime startedAt,
            DateTime submittedAt)
        {
            var sql = @"
                INSERT INTO user_lesson_results (user_id, lesson_id, total_questions, total_correct, score, started_at, submitted_at)
                VALUES (@UserId, @LessonId, @TotalQuestions, @TotalCorrect, @Score, @StartedAt, @SubmittedAt)
                RETURNING id;";

            var resultId = await _dbConnection.ExecuteScalarAsync<int>(sql, new
            {
                UserId = userId,
                LessonId = lessonId,
                TotalQuestions = totalQuestions,
                TotalCorrect = totalCorrect,
                Score = score,
                StartedAt = startedAt,
                SubmittedAt = submittedAt
            });

            return resultId;
        }

        public async Task SaveUserAnswerAsync(int resultId, int questionId, string answerText, bool isCorrect)
        {
            var sql = @"
                INSERT INTO user_question_answers (user_result_id, question_id, answer_text, is_correct)
                VALUES (@ResultId, @QuestionId, @AnswerText, @IsCorrect);";

            await _dbConnection.ExecuteAsync(sql, new
            {
                ResultId = resultId,
                QuestionId = questionId,
                AnswerText = answerText,
                IsCorrect = isCorrect
            });
        }

        public async Task<List<string>> GetCorrectAnswersAsync(int questionId)
        {
            var sql = @"
                SELECT LOWER(answer_text) 
                FROM question_answers
                WHERE question_id = @QuestionId AND is_correct = TRUE;";

            var answers = await _dbConnection.QueryAsync<string>(sql, new { QuestionId = questionId });
            return answers.ToList();
        }
        public async Task<IEnumerable<UserExerciseAnswer>> GetUserAnswersByResultIdAsync(int resultId)
        {
            var sql = @"
                SELECT id, user_result_id AS UserResultId, question_id AS QuestionId, answer_text AS AnswerText, is_correct AS IsCorrect, answered_at AS AnsweredAt
                FROM user_question_answers
                WHERE user_result_id = @ResultId;";

            return await _dbConnection.QueryAsync<UserExerciseAnswer>(sql, new { ResultId = resultId });
        }

        public async Task<IEnumerable<UserLessonResult>> GetLessonResultsByUserIdAsync(int userId)
        {
            var sql = @"
                SELECT id, user_id AS UserId, lesson_id AS LessonId, score, submitted_at AS CreatedAt
                FROM user_lesson_results
                WHERE user_id = @UserId
                ORDER BY submitted_at DESC;";

            return await _dbConnection.QueryAsync<UserLessonResult>(sql, new { UserId = userId });
        }
    }
}
