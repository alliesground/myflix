class ReviewsController < ApplicationController
  before_action :authenticate
  
  def create
    @video = Video.find_by(id: params[:video_id])
    review = Review.find_by(user_id: current_user, video_id: params[:video_id])

    if review.present?
      review.update(rating: review_params[:rating], body: review_params[:body])
      @reviews = @video.reviews.reload
      redirect_to @video
    else
      review = @video.reviews.build(review_params.merge!(user: current_user))
      if review.save
        redirect_to @video
      else
        @reviews = @video.reviews.reload
        render 'videos/show'
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
