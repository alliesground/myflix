class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items

  validates_presence_of :title, :description

  mount_uploader :large_cover_url, LargeCoverUploader
  mount_uploader :small_cover_url, SmallCoverUploader

  def self.search_by_title (search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%")
  end

  def avg_rating
    self.reviews.average(:rating).to_f
  end
end
