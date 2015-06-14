class UsersController < ApplicationController
  before_action :authenticate, only: [:show]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, success: "Congratulation! you have successfully created an account"
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