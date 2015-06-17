class InvitationsController < ApplicationController
  before_action :authenticate, only: [:new, :create]

  def create
    if valid_input?
      send_invitation
      flash[:success] = "Your invitation has been sent"
      redirect_to home_path
    else
      flash.now[:danger] = "Email field must not be blank"
      render :new
    end
  end

  private

  def valid_input?
    params[:email].present?
  end

  def send_invitation
    UserMailer.send_friend_invitation(current_user, params[:name], params[:email], params[:message]).deliver
  end
end