class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }

  validates_presence_of :title, :description

  def self.search_by_title (search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%")
  end

  def avg_rating
    self.reviews.average(:rating).to_f
  end
end
