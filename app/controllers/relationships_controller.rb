class RelationshipsController < ApplicationController
  before_action :authenticate

  def index
    @relationships = current_user.relationships
  end

  def create
    other_user = User.find(params[:followed_id])
    
    if !current_user.following?(other_user)
      @current_user.relationships.create(followed_id: params[:followed_id])
      flash[:success] = "You have successfully added a friend"
    else
      flash[:warning] = "You are already following this user"
    end
    redirect_to people_path
  end

  def destroy
    relationship = current_user.relationships.find_by(id: params[:id])
    if relationship
      relationship.destroy
      flash[:success] = "You have successfully removed a friend"
    else
      flash[:warning] = "You cannot destroy other's relationships"
    end
    redirect_to people_path
  end
end