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

  def destroy
    queue_item = QueueItem.find(params[:id])
    if queue_item.user == current_user
      queue_item.destroy
      normalize_queue
      redirect_to my_queue_path
    else
      flash[:warning] = "You cannot delete other users queue item"
      redirect_to my_queue_path
    end
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        params[:items].each do |queue_item|
          item = QueueItem.find(queue_item["id"])
          if item.user == current_user
            item.update!(position: queue_item["position"])
          end
        end
      end
      normalize_queue
    rescue Exception => e
      flash[:danger] = e.message
    end
    redirect_to my_queue_path
  end


  private

  def queue_video(video)
    QueueItem.create(video: video, 
      user: current_user, 
      position: current_user.queue_items.count + 1)
  end

  def normalize_queue
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index+1)
    end
  end

end