class SessionsController < ApplicationController
	def create
		user = User.find_by(email: params[:session][:email])
		if user
			flash[:notice] = "Logged in successfully"
		else
			flash[:danger] = "Incorrect email or password. Please try again."
			render :new
		end
	end
end