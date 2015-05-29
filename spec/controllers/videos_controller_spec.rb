require 'spec_helper'

describe VideosController do
	describe 'POST #search' do
		it "assigns the search results to @search_result" do
			futurama = create(:video)
			get :search, search: "futurama"
			expect(assigns(:search_result)).to match_array([futurama])
		end
	end
end
