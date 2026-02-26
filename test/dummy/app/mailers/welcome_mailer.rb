class WelcomeMailer < ApplicationMailer
  def new_account(user_name: "Jane Doe", user_email: "jane@example.com")
    @user_name  = user_name
    @user_email = user_email
    @login_url  = "https://myapp.com/dashboard"

    mail(
      to:      "#{user_name} <#{user_email}>",
      subject: "Welcome to MyApp!"
    )
  end

  def confirm_email(user_name: "Jane Doe", user_email: "jane@example.com")
    @user_name        = user_name
    @confirmation_url = "https://myapp.com/confirm?token=a1b2c3d4e5f6"

    mail(
      to:      "#{user_name} <#{user_email}>",
      subject: "Please confirm your email"
    )
  end
end
