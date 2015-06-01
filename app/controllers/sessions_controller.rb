class SessionsController < ApplicationController
	before_action only: :new do
		if logged_in?
			flash[:warning] = "First sign out the current user"
			redirect_to root_path
		end
	end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			log_in user
			flash[:success] = "Logged in successfully"
			redirect_to home_path
		else
			flash.now[:danger] = "Incorrect email or password. Please try again."
			render :new
		end
	end

	def destroy
		log_out
		redirect_to root_path
	end
end