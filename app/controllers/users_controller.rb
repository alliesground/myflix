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
      return
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999, 
        currency: "usd", 
        source: params[:stripeToken]
      )

      if charge.success?
        flash[:success] = "Congrats people"
        @user.save
        handle_invitation
        UserMailer.welcome_registered_user(@user).deliver
        redirect_to login_path
      else
        flash[:danger] = charge.error_message
        render :new
      end
    else
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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.update_column(:token, nil)
    end
  end

end