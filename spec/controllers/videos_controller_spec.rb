require 'spec_helper'

describe VideosController do
  describe 'GET #show' do
    context "with authenticated user" do
      before :each do
        @user = create(:user)
        session[:user_id] = @user.id
      end

      it "finds the requested video" do
        video = create(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq video
      end

      it "sets @reviews" do
        video = create(:video)
        review_1 = create(:review, video: video)
        review_2 = create(:review, video: video)
        get :show, id: video.id
        expect(assigns(:reviews)).to eq [review_2, review_1]
      end
    end

    it "redirects to the home page for unauthenticated user" do
      video = create(:video)
      get :show, id: video.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST #search' do
    let(:video){ create(:video, title: "futurama") }
    it "sets @search_result for authenticated user" do
      session[:user_id] = create(:user).id
      futurama = create(:video, title: "futurama")
      get :search, search: "futu"
      expect(assigns(:search_result)).to match_array([futurama])
    end

    it "redirects to home page for unauthenticated user" do
      get :search, search: "futu"
      expect(response).to redirect_to root_path
    end
  end
end
