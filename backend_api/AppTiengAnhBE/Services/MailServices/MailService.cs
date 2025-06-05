using AppTiengAnhBE.Models.DTOs.ReminderDTO;
using Hangfire;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace AppTiengAnhBE.Services.MailServices
{
    public class MailService
    {
        //public async Task ScheduleReminderAsync(ReminderDTO dto)
        //{
        //    var now = DateTime.Now;
        //    var remindTimeToday = now.Date + dto.TimeToRemind;

        //    if (remindTimeToday < now)
        //        remindTimeToday = remindTimeToday.AddDays(1);

        //    var delay = remindTimeToday - now;

        //    // Truyền email người nhận vào SendEmailAsync
        //    BackgroundJob.Schedule(() => SendEmailAsync(dto.Email), delay);
        //}

        //public async Task SendEmailAsync(string toEmail)
        //{
        //    try
        //    {
        //        var message = new MimeMessage();
        //        message.From.Add(new MailboxAddress("RingoLingo", "thubeztdaxuo@gmail.com"));
        //        message.To.Add(MailboxAddress.Parse(toEmail));
        //        message.Subject = "Nhắc học bài";
        //        message.Body = new TextPart("plain")
        //        {
        //            Text = "Nhớ học bài nhé!"
        //        };

        //        using var client = new SmtpClient();
        //        await client.ConnectAsync("smtp.gmail.com", 587, SecureSocketOptions.StartTls);
        //        await client.AuthenticateAsync("thubeztdaxuo@gmail.com", "msks mlki xqgi rqnm");
        //        await client.SendAsync(message);
        //        await client.DisconnectAsync(true);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine($"Lỗi gửi mail: {ex.Message}");
        //        throw;
        //    }
        //}
        public async Task SendEmailAsync(string toEmail)
        {
            var message = new MimeMessage();
            message.From.Add(new MailboxAddress("RingoLingo", "thubeztdaxuo@gmail.com"));
            message.To.Add(MailboxAddress.Parse(toEmail));
            message.Subject = "Nhắc học bài";
            message.Body = new TextPart("plain")
            {
                Text = "Nhớ học bài nhé!"
            };

            using var client = new SmtpClient();
            await client.ConnectAsync("smtp.gmail.com", 587, SecureSocketOptions.StartTls);
            await client.AuthenticateAsync("thubeztdaxuo@gmail.com", "msks mlki xqgi rqnm"); // App password
            await client.SendAsync(message);
            await client.DisconnectAsync(true);
        }

        // Phương thức này dùng để lên lịch
        public async Task ScheduleReminderAsync(ReminderDTO dto)
        {
            var now = DateTime.Now;
            var remindTimeToday = now.Date + dto.TimeToRemind;

            if (remindTimeToday <= now)
                remindTimeToday = remindTimeToday.AddDays(1);

            var delay = remindTimeToday - now;
            Hangfire.BackgroundJob.Schedule(() => SendEmailAsync(dto.Email), delay);
        }

        // Gửi mail ngay lập tức, không qua lịch
        public async Task SendEmailImmediatelyAsync(string toEmail)
        {
            await SendEmailAsync(toEmail);
        }
    }
}
