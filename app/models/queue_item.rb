class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  validates_numericality_of :position, {only_integer: true}

  def self.contains_video?(video, user)
    queue_item = QueueItem.where(video: video, user: user).first
    return true if queue_item
  end

  def video_title
    video.title
  end

  def category_name
    category.name
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
end