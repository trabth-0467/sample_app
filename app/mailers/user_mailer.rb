class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: @user.email, subject: t("account_activations.mailer.subject")
  end

  def password_reset user
    @user = user
    @reset_token = @user.reset_token
    mail to: @user.email, subject: t("password.subject")
  end
end
