namespace AppTiengAnhBE.Domain.Entities
{
    public class JwtSettings
    {
        public required string SecretKey { get; set; }
        public required string RefreshSecretKey { get; set; }
        public required double RefreshExpireDays {get; set; }   
        public required string Issuer { get; set; }
        public required string Audience { get; set; }
        public int ExpireMinutes { get; set; }
    }
}
