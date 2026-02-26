class TransactionalMailerPreview < ActionMailer::Preview
  def password_reset
    TransactionalMailer.password_reset
  end

  def magic_link
    TransactionalMailer.magic_link
  end
end
