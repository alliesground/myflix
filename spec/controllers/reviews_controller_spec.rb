require 'spec_helper'

describe ReviewsController do
  describe 'POST #create' do
    context "with authenticated user" do
      login_user
      let(:video) { create(:video) }

      context "with valid input" do
        before :each do
          post :create, review: attributes_for(:review), video_id: video.id
        end

        it "saves the review" do
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          expect(Review.first.video).to eq video
        end
        it "creates a review associated with the current user" do
          expect(Review.first.user).to eq current_user
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to video_path video
        end
      end

      context "with invalid input" do
        it "does not create a review" do
          expect{
            post :create, review: {rating: 4}, video_id: video.id
          }.to_not change(Review, :count)
        end

        it "renders videos/show template" do
          post :create, review: {rating: 4}, video_id: video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq video
        end

        it "sets @reviews" do
          review_1 = create(:review, video: video)
          review_2 = create(:review, video: video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:reviews)).to eq [review_2, review_1]
        end
      end
    end

    context "with unauthenticated user" do
      let(:video) { create(:video) }
      it_behaves_like 'require sign in' do
        let(:action) do
          post :create, review: attributes_for(:review, user: nil ), video_id: video.id
        end
      end
    end
  end
end