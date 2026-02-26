class WelcomeMailerPreview < ActionMailer::Preview
  def new_account
    WelcomeMailer.new_account
  end

  def confirm_email
    WelcomeMailer.confirm_email
  end
end
