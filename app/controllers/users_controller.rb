class UsersController < ApplicationController
  before_action :authenticate, only: [:show]
  before_action only: [:new, :create] do
    if logged_in?
      flash[:warning] = "First sign out the current user"
      redirect_to root_path
    end
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, success: "Congratulation! you have successfully created an account"
      UserMailer.welcome_registered_user(@user).deliver
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

end