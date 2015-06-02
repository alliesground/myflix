require 'spec_helper'

describe VideosController do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe 'GET #show' do
    it "finds the requested video" do
      video = create(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq video
    end

    it "does not find the requested video" do
      get :show, id: 1
      expect(assigns(:video)).to eq nil
    end
  end

  describe 'POST #search' do
    context "with no match" do
      it "assigns an empty array to @search_result" do
        get :search, search: "futurama"
        expect(assigns(:search_result)).to match_array([])
      end
    end

    context "with single match" do
      it "assigns the result to @search_result" do
        futurama = create(:video)
        get :search, search: "futurama"
        expect(assigns(:search_result)).to match_array([futurama])
      end
    end

    context "with multiple match" do
      it "assigns multiple results to @search_result" do
        south_country = create(:video, title: 'south_country')
        south_park = create(:video, title: 'south_park')
        get :search, search: "south"
        expect(assigns(:search_result)).to match_array([south_country, south_park])
      end
    end
  end
end
