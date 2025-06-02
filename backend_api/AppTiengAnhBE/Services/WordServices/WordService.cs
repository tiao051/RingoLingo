using AppTiengAnhBE.Models.DTOs.WordDTO;
using AppTiengAnhBE.Repositories.WordRepo;

namespace AppTiengAnhBE.Services.WordServices
{
    public class WordService : IWordService
    {
        private readonly IWordRepository _repository;

        public WordService(IWordRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<WordDTO>> GetWordsByCategoryAndLessonAsync(int categoryId, int lessonId)
        {
            return await _repository.GetWordsByCategoryAndLessonAsync(categoryId, lessonId);
        }
    }
}
