﻿using AppTiengAnhBE.Models.DTOs.QuestionDTO;
using Dapper;
using System.Data;
using System.Data.Common;

namespace AppTiengAnhBE.Repositories.QuestionRepo
{
    public class QuestionRepository : IQuestionRepository
    {
        private readonly IDbConnection _db;

        public QuestionRepository(IDbConnection db)
        {
            _db = db;
        }

        public async Task<IEnumerable<QuestionDTO>> GetQuestionsByLessonAsync(int lessonId)
        {
            var sql = @"
        WITH paged_questions AS (
            SELECT q.id, q.question AS QuestionText, qt.type_name AS TypeName
            FROM question q
            JOIN question_types qt ON q.question_type_id = qt.id
            WHERE q.lesson_id = @LessonId
            ORDER BY q.id DESC
            OFFSET 5
            LIMIT 5
        )
        SELECT * FROM paged_questions
        ORDER BY id;

        SELECT qa.id, qa.question_id AS QuestionId, qa.answer_text AS AnswerText, qa.is_correct AS isCorrect
        FROM question_answers qa
        WHERE qa.question_id IN (
            SELECT id FROM (
                SELECT q.id
                FROM question q
                WHERE q.lesson_id = @LessonId
                ORDER BY q.id DESC
                OFFSET 5
                LIMIT 5
            ) AS filtered
        );";

            using var multi = await _db.QueryMultipleAsync(sql, new { LessonId = lessonId });

            var questions = (await multi.ReadAsync<QuestionDTO>()).ToList();
            var answers = (await multi.ReadAsync<AnswerDTO>()).ToList();

            foreach (var q in questions)
            {
                q.AnswersText = answers.Where(a => a.QuestionId == q.Id).ToList();
            }

            return questions;
        }

        public async Task<IEnumerable<QuestionDTO>> GetQuestionsForLisTestByLessonAsync(int lessonId)
        {
            var sql = @"
    WITH latest_questions AS (
        SELECT q.id, q.question AS QuestionText, qt.type_name AS TypeName
        FROM question q
        JOIN question_types qt ON q.question_type_id = qt.id
        WHERE q.lesson_id = @LessonId
        ORDER BY q.id DESC
        LIMIT 5
    )
    SELECT * FROM latest_questions
    ORDER BY id; -- sắp xếp lại theo thứ tự tăng dần nếu cần

    SELECT qa.id, qa.question_id AS QuestionId, qa.answer_text AS AnswerText, qa.is_correct AS isCorrect
    FROM question_answers qa
    WHERE qa.question_id IN (
        SELECT id FROM (
            SELECT q.id
            FROM question q
            WHERE q.lesson_id = @LessonId
            ORDER BY q.id DESC
            LIMIT 5
        ) AS filtered
    );";

            using var multi = await _db.QueryMultipleAsync(sql, new { LessonId = lessonId });

            var questions = (await multi.ReadAsync<QuestionDTO>()).ToList();
            var answers = (await multi.ReadAsync<AnswerDTO>()).ToList();

            foreach (var q in questions)
            {
                q.AnswersText = answers.Where(a => a.QuestionId == q.Id).ToList();
            }

            return questions;
        }


        public async Task<IEnumerable<QuestionDTO>> GetWrongQuestionsWithAnswersAsync(int userResultId)
        {
            // Lấy danh sách ID các câu sai
            var getIdsSql = @"
                SELECT DISTINCT q.id
                FROM user_question_answers uqa
                JOIN question q ON uqa.question_id = q.id
                WHERE uqa.user_result_id = @UserResultId
                AND uqa.is_correct = false";

            var wrongQuestionIds = (await _db.QueryAsync<int>(getIdsSql, new { UserResultId = userResultId })).ToList();

            if (!wrongQuestionIds.Any())
                return new List<QuestionDTO>();

            // Lấy câu hỏi theo ID
            var getQuestionsSql = @"
                SELECT q.id, q.question AS QuestionText, qt.type_name AS TypeName
                FROM question q
                JOIN question_types qt ON q.question_type_id = qt.id
                WHERE q.id = ANY(@WrongQuestionIds)";  // Dùng ANY cho Postgres

            var questions = (await _db.QueryAsync<QuestionDTO>(getQuestionsSql, new { WrongQuestionIds = wrongQuestionIds })).ToList();

            // Lấy câu trả lời theo ID câu hỏi sai
            var getAnswersSql = @"
                SELECT qa.id, qa.question_id AS QuestionId, qa.answer_text AS AnswerText, qa.is_correct AS IsCorrect
                FROM question_answers qa
                WHERE qa.question_id = ANY(@WrongQuestionIds)";

            var answers = (await _db.QueryAsync<AnswerDTO>(getAnswersSql, new { WrongQuestionIds = wrongQuestionIds })).ToList();

            // Map câu trả lời vào câu hỏi
            foreach (var q in questions)
                q.AnswersText = answers.Where(a => a.QuestionId == q.Id).ToList();

            return questions;
        }
    }
}
