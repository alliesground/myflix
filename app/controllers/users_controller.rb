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
    invitation_token = params[:invitation_token] ||= nil
    
    if @user.save
      flash[:success] = "Thank you for signing up"
      #UserMailer.welcome_registered_user(@user).deliver
      #handle_invitation(@user, invitation_token) unless invitation_token.nil?

      redirect_to login_path
    else
      flash[:danger] = "Invalid user information"
      render :new
    end



#    stripe_token = params[:stripeToken]
#    invitation_token = params[:invitation_token] ||= nil
#
#    response = UserSignup.new(@user).save_with_subscription(stripe_token, invitation_token)
#
#    if response.successful?
#      flash[:success] = "Thank you for subscribing"
#      redirect_to login_path
#    else
#      flash[:danger] = response.error_message
#      render :new
#    end
  end

  def show
    @user = User.find(params[:id])
  end

private
  
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation(user, invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      user.follow(invitation.inviter)
      invitation.update_column(:token, nil)
    end
  end

end
