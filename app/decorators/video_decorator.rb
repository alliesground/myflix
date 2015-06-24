class VideoDecorator < Draper::Decorator
  delegate_all

  def rating?
    if reviews.present?
      "#{avg_rating} / 5.000"
    else
      "N/A"
    end
  end
end