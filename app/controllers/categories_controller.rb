class CategoriesController < ApplicationController
	before_action :authenticate
	
  def show
  	if @category = Category.find_by(id: params[:id])
  		@category
  	else
  		flash[:warning] = "Sorry couldn't find the requested category"
  		redirect_to home_path
  	end
  end
end
