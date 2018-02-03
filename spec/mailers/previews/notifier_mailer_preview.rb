# Preview all emails at http://localhost:3000/rails/mailers/notifier_mailer
class NotifierMailerPreview < ActionMailer::Preview
  def notifier_mail_preview
    NotifierMailer.daily_stats_email(20, 15, 10)
  end
end
