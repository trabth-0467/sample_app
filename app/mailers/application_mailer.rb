class ApplicationMailer < ActionMailer::Base
  default from: Settings.smtp.user_name
  layout "mailer"
end
