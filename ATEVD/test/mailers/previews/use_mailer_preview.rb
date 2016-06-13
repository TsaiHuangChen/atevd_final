# Preview all emails at http://localhost:3000/rails/mailers/use_mailer
class UseMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/use_mailer/alert_comment
  def alert_comment
    UseMailer.alert_comment
  end

end
