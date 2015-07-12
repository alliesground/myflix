class UsersController < ApplicationController
  before_action :authenticate, only: [:show]
  before_action only: [:new, :create, :new_with_invitation_token] do
    if logged_in?
      flash[:warning] = "First sign out the current user"
      redirect_to root_path
    end
  end
  
  def new
    @user = User.new
  end

  def new_with_invitation_token
    if @invitation = Invitation.find_by(token: params[:token])
      @user = User.new(email: @invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    stripe_token = params[:stripeToken]
    invitation_token = params[:invitation_token] ||= nil

    response = UserSignup.new(@user).save_with_subscription(stripe_token, invitation_token)

    if response.successful?
      flash[:success] = "Thank you for subscribing"
      redirect_to login_path
    else
      flash[:danger] = response.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

private
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

end