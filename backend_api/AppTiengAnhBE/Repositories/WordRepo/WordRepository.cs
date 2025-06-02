using AppTiengAnhBE.Models.DTOs.WordDTO;
using Dapper;
using System.Data;

namespace AppTiengAnhBE.Repositories.WordRepo
{
    public class WordRepository : IWordRepository
    {
        private readonly IDbConnection _db;

        public WordRepository(IDbConnection db)
        {
            _db = db;
        }

        public async Task<IEnumerable<WordDTO>> GetWordsByCategoryAndLessonAsync(int categoryId, int lessonId)
        {
            var sql = @"
                SELECT w.id, w.word, w.pronunciation, w.image_url AS ImageUrl, w.audio_url AS AudioUrl,
                       wt.meaning, wt.example_sentence AS ExampleSentence
                FROM words w
                JOIN word_translations wt ON w.id = wt.word_id
                WHERE w.category_id = @CategoryId AND w.lesson_id = @LessonId
                      AND wt.language_code = 'vi';";

            return await _db.QueryAsync<WordDTO>(sql, new { CategoryId = categoryId, LessonId = lessonId });
        }
    }

}
