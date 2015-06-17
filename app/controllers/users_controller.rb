class UsersController < ApplicationController
  before_action :authenticate, only: [:show]
  before_action only: [:new, :create] do
    if logged_in?
      flash[:warning] = "First sign out the current user"
      redirect_to root_path
    end
  end
  
  def new
    if invited_user?
      @inviter_id = params[:inviter_id]
      @user = User.new(email: params[:email])
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if invited_user?
        @user.relationships.create(followed_id: params[:inviter_id].to_i)
      end
      
      flash[:success] = "Congratulation! you have successfully created an account"
      
      UserMailer.welcome_registered_user(@user).deliver
      redirect_to login_path
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

  def invited_user?
    params[:email].present? || params[:inviter_id].present?
  end

end