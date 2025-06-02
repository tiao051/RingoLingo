namespace AppTiengAnhBE.Models.DTOs.WordDTO
{
    public class WordDTO
    {
        public int Id { get; set; }
        public required string Word { get; set; }
        public required string Pronunciation { get; set; }
        public required string ImageUrl { get; set; }
        public required string AudioUrl { get; set; }
        public required string Meaning { get; set; }
        public required string ExampleSentence { get; set; }
    }
}
