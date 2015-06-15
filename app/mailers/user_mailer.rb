class UserMailer < ActionMailer::Base
  def welcome_registered_user(user)
    @user = user
    mail from: "admin@myflix.com", to: @user.email, subject: "Welcome to Myflix"
  end
end