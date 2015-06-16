class UserMailer < ActionMailer::Base
  def welcome_registered_user(user)
    @user = user
    mail from: "admin@myflix.com", to: @user.email, subject: "Welcome to Myflix"
  end

  def send_password_reset_link(user)
    @user = user
    mail from: 'admin@myflix.com', to: @user.email, subject: 'Password reset'
  end
end