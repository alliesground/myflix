class VideosController < ApplicationController
  before_action :authenticate
  
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find_by(id: params[:id]).decorate
    @reviews = @video.reviews
  end

  def search
    @search_result = Video.search_by_title(params[:search])
  end
end
