using AppTiengAnhBE.Domain.Entities;
using AppTiengAnhBE.Repositories.LessonRepository.LessonsCRUDRepo;

namespace AppTiengAnhBE.Services.LessonServices.LessonsCRUDServices
{
    public interface ILessonService
    {
        Task<IEnumerable<Lesson>> GetAllLessonsAsync();
        Task<Lesson> GetLessonByIdAsync(int id);
        Task<int> CreateLessonAsync(Lesson lesson);
        Task<int> UpdateLessonAsync(Lesson lesson);
        Task<int> DeleteLessonAsync(int id);
    }

    public class LessonService : ILessonService
    {
        private readonly ILessonRepository _lessonRepository;
        public LessonService(ILessonRepository lessonRepository)
        {
            _lessonRepository = lessonRepository;
        }
        public async Task<IEnumerable<Lesson>> GetAllLessonsAsync()
        {
            return await _lessonRepository.GetAllLessonsAsync();
        }
        public async Task<Lesson> GetLessonByIdAsync(int id)
        {
            return await _lessonRepository.GetLessonByIdAsync(id);
        }
        public async Task<int> CreateLessonAsync(Lesson lesson)
        {
            return await _lessonRepository.CreateLessonAsync(lesson);
        }
        public async Task<int> UpdateLessonAsync(Lesson lesson)
        {
            return await _lessonRepository.UpdateLessonAsync(lesson);
        }
        public async Task<int> DeleteLessonAsync(int id)
        {
            return await _lessonRepository.DeleteLessonAsync(id);
        }
    }
}
