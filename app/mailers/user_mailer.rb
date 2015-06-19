class UserMailer < ActionMailer::Base
  def welcome_registered_user(user)
    @user = user
    mail from: "admin@myflix.com", to: ENV['admin_email'] || @user.email, subject: "Welcome to Myflix"
  end

  def send_password_reset_link(user)
    @user = user
    mail from: 'admin@myflix.com', to: @user.email, subject: 'Password reset'
  end

  def send_friend_invitation(invitation)
    @invitation = invitation
    mail from: invitation.inviter.email, to: invitation.recipient_email, subject: 'Invitation to Myflix'
  end
end