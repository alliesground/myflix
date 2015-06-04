class QueueItemsController < ApplicationController
  before_action :authenticate
  
  def index
    @queue_items = current_user.queue_items
  end
end