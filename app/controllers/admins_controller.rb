class AdminsController < ApplicationController
  before_action :authenticate
  before_action :ensure_admin

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path
      flash[:warning] = "You dont have access to this page"
    end
  end
end