using AppTiengAnhBE.Models.DTOs.WordDTO;

namespace AppTiengAnhBE.Services.WordServices
{
    public interface IWordService
    {
        Task<IEnumerable<WordDTO>> GetWordsByCategoryAndLessonAsync(int categoryId, int lessonId);
    }
}
