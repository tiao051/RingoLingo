namespace AppTiengAnhBE.Domain.Entities
{
    public class Lesson
    {
        public int id { get; set; }
        public int category_id { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public int order_num { get; set; }
        public DateTime created_at { get; set; }
    }
}
