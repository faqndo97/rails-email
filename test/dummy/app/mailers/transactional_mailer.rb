class TransactionalMailer < ApplicationMailer
  def password_reset(user_email: "jane@example.com")
    @reset_url  = "https://myapp.com/password/reset?token=xyz789abc123def"
    @expires_in = "1 hour"

    mail(
      to:      user_email,
      subject: "Reset your password"
    )
  end

  def magic_link(user_email: "jane@example.com")
    @magic_url  = "https://myapp.com/auth/magic?code=preview_code_12345"
    @expires_in = "15 minutes"

    mail(
      to:      user_email,
      subject: "Your sign-in link"
    )
  end
end
