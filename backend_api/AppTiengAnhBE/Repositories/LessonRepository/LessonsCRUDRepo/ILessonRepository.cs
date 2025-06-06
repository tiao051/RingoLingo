using AppTiengAnhBE.Domain.Entities;

namespace AppTiengAnhBE.Repositories.LessonRepository.LessonsCRUDRepo
{
    public interface ILessonRepository
    {
        Task<IEnumerable<Lesson>> GetAllLessonsAsync();
        Task<IEnumerable<Lesson>> GetLessonsByCategoryIdAsync(int categoryId);
        Task<int> CreateLessonAsync(Lesson lesson);
        Task<int> UpdateLessonAsync(Lesson lesson);
        Task<int> DeleteLessonAsync(int id);
    }
}
