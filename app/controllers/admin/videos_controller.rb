class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    category_id = params[:video].delete(:category_id)
    @video = Video.new(video_params.merge!(category_id: category_id))

    if @video.save
      flash[:success] = "Video created successfully"
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end
end