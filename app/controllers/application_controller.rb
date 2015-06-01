class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

protected
  def authenticate
  	if !current_user
  		flash[:danger] = "You need to first log in"
  		redirect_to root_path
  	end
  end
end
