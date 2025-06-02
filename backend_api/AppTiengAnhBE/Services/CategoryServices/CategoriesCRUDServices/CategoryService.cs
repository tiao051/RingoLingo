using AppTiengAnhBE.Models.SystemModel;
using AppTiengAnhBE.Repositories.CategoryServices.CategoriesCRUDRepo;

namespace AppTiengAnhBE.Services.CategoryServices.CategoriesCRUDServices
{
    public interface ICategoryService
    {
        Task<IEnumerable<Category>> GetAllCategoriesAsync();
        Task<Category> GetCategoryByIdAsync(int id);
        Task<int> CreateCategoryAsync(Category category);
        Task<int> UpdateCategoryAsync(Category category);
        Task<int> DeleteCategoryAsync(int id);
    }
    public class CategoryService : ICategoryService
    {
        private readonly ICategoryRepository _categoryRepository;
        public CategoryService(ICategoryRepository categoryRepository)
        {
            _categoryRepository = categoryRepository;
        }
        public async Task<IEnumerable<Category>> GetAllCategoriesAsync() => await _categoryRepository.GetAllCategoriesAsync();
        public async Task<Category> GetCategoryByIdAsync(int id) => await _categoryRepository.GetCategoryByIdAsync(id);
        public async Task<int> CreateCategoryAsync(Category category) => await _categoryRepository.CreateCategoryAsync(category);
        public async Task<int> UpdateCategoryAsync(Category category) => await _categoryRepository.UpdateCategoryAsync(category);
        public async Task<int> DeleteCategoryAsync(int id) => await _categoryRepository.DeleteCategoryAsync(id);
    }
}
