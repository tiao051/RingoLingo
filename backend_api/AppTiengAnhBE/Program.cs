using System.Data;
using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.Google;
using Npgsql;

// Repositories
using AppTiengAnhBE.Repositories.CategoryServices.CategoriesCRUDRepo;
using AppTiengAnhBE.Repositories.LessonRepository.LessonResults;
using AppTiengAnhBE.Repositories.LessonRepository.LessonsCRUDRepo;
using AppTiengAnhBE.Repositories.QuestionRepo;
using AppTiengAnhBE.Repositories.RemindersCRUDRepo;
using AppTiengAnhBE.Repositories.UserRepository.UserCRUDRepo;
using AppTiengAnhBE.Repositories.UserRepository.UserQuestionAnswers;
using AppTiengAnhBE.Repositories.WordRepo;

// Services
using AppTiengAnhBE.Services.CategoryServices.CategoriesCRUDServices;
using AppTiengAnhBE.Services.LessonServices.LessonResults;
using AppTiengAnhBE.Services.LessonServices.LessonsCRUDServices;
using AppTiengAnhBE.Services.QuestionServices;
using AppTiengAnhBE.Services.RemindersCRUDServices;
using AppTiengAnhBE.Services.UserServices.UserCRUDServices;
using AppTiengAnhBE.Services.UserServices.UserQuestionAnswers;
using AppTiengAnhBE.Services.WordServices;
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using AppTiengAnhBE.Domain.Entities;
using AppTiengAnhBE.Services.AuthServices;
using AppTiengAnhBE.Services;
using Hangfire;
using Hangfire.MemoryStorage;
using AppTiengAnhBE.Services.MailServices;

var builder = WebApplication.CreateBuilder(args);

// Đăng ký JwtSettings
builder.Services.Configure<JwtSettings>(
    builder.Configuration.GetSection("JwtSettings"));

// Cấu hình JWT Authentication
var jwtSettings = builder.Configuration.GetSection("JwtSettings").Get<JwtSettings>();
var key = Encoding.UTF8.GetBytes(jwtSettings.SecretKey);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false; // dev only
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidIssuer = jwtSettings.Issuer,
        ValidAudience = jwtSettings.Audience,
        ValidateLifetime = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuerSigningKey = true
    };
});

// Database connection
builder.Services.AddScoped<IDbConnection>(sp =>
    new NpgsqlConnection(builder.Configuration.GetConnectionString("DefaultConnection")));

// JSON configuration
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
    options.JsonSerializerOptions.DictionaryKeyPolicy = JsonNamingPolicy.CamelCase;
    options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
});

// API Documentation
builder.Services.AddOpenApi();
builder.Services.AddScoped<MailService>();

// Repository registrations
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<ILessonRepository, LessonRepository>();
builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
builder.Services.AddScoped<IReminderRepository, ReminderRepository>();
builder.Services.AddScoped<ILessonResultRepository, LessonResultRepository>();
builder.Services.AddScoped<IUserQuestionAnswerRepository, UserQuestionAnswerRepository>();
builder.Services.AddScoped<IQuestionRepository, QuestionRepository>();
builder.Services.AddScoped<IWordRepository, WordRepository>();

// Service registrations
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<ILessonService, LessonService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IReminderService, ReminderService>();
builder.Services.AddScoped<ILessonResultService, LessonResultService>();
builder.Services.AddScoped<IUserQuestionAnswerService, UserQuestionAnswerService>();
builder.Services.AddScoped<IQuestionService, QuestionService>();
builder.Services.AddScoped<IWordService, WordService>();
builder.Services.AddScoped<IAuthService, AuthService>();

builder.Services.AddHangfire(x => x.UseMemoryStorage()); // hoặc dùng SQL
builder.Services.AddHangfireServer();

//cors
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Authentication configuration
builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = CookieAuthenticationDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = GoogleDefaults.AuthenticationScheme;
})
.AddCookie()
.AddGoogle(googleOptions =>
{
    googleOptions.ClientId = builder.Configuration["Authentication:Google:ClientId"] ?? "";
    googleOptions.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"] ?? "";
});

builder.Services.AddAuthorization();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseDeveloperExceptionPage();
}

app.UseHangfireServer();
app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

// Google OAuth test routes
app.MapGet("/login-google", async (HttpContext context) =>
{
    await context.ChallengeAsync(GoogleDefaults.AuthenticationScheme, new AuthenticationProperties
    {
        RedirectUri = "/google-response"
    });
});

app.MapGet("/google-response", (HttpContext context) =>
{
    var user = context.User;

    if (user?.Identity?.IsAuthenticated ?? false)
    {
        var email = user.FindFirst(c => c.Type == ClaimTypes.Email)?.Value;
        var name = user.FindFirst(c => c.Type == ClaimTypes.Name)?.Value;

        return Results.Ok(new { email, name });
    }

    return Results.Unauthorized();
});

app.Run();
