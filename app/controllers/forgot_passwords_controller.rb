class ForgotPasswordsController < ApplicationController
  def create
    if user = User.find_by(email: params[:email])
      UserMailer.send_password_reset_link(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:warning] = "The email address does not exist"
      redirect_to forgot_password_path
    end
  end

  def edit
    @token = params[:id]
  end

  def update
    if user = User.find_by(token: params[:token])
      user.update(password: params[:new_password], token: SecureRandom.urlsafe_base64)
      redirect_to login_path
    else
      redirect_to expired_token_path
    end
  end
end