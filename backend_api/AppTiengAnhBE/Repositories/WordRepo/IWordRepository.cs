using AppTiengAnhBE.Models.DTOs.WordDTO;

namespace AppTiengAnhBE.Repositories.WordRepo
{
    public interface IWordRepository
    {
        Task<IEnumerable<WordDTO>> GetWordsByCategoryAndLessonAsync(int categoryId, int lessonId);
    }
}
