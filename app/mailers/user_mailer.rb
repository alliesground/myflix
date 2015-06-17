class UserMailer < ActionMailer::Base
  def welcome_registered_user(user)
    @user = user
    mail from: "admin@myflix.com", to: @user.email, subject: "Welcome to Myflix"
  end

  def send_password_reset_link(user)
    @user = user
    mail from: 'admin@myflix.com', to: @user.email, subject: 'Password reset'
  end

  def send_friend_invitation(current_user, friend_name, friend_email, message)
    @name = friend_name
    @email = friend_email
    @message = message
    @current_user_id = current_user.id
    
    mail from: current_user.email, to: friend_email, subject: 'Invitation to Myflix'
  end
end