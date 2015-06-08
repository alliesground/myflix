require 'spec_helper'

describe VideosController do
  describe 'GET #show' do
    context "with authenticated user" do
      login_user

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

    context "with unauthenticated user" do
      it_behaves_like 'require sign in' do
        let(:action) do
          video = create(:video)
          get :show, id: video.id
        end
      end
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

    context "with unauthenticated user" do
      it_behaves_like 'require sign in' do
        let(:action) { get :search, search: "futu" }
      end
    end
  end
end
