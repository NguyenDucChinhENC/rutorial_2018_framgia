class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.mail.title")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailer.pass.title")
  end
end
