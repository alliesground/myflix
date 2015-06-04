class QueueItemsController < ApplicationController
  before_action :authenticate

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    if !QueueItem.contains_video?(video, current_user)
      queue_video(video)
      redirect_to my_queue_path
    else
      redirect_to my_queue_path  
    end
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, 
      user: current_user, 
      position: current_user.queue_items.count + 1)
  end

end