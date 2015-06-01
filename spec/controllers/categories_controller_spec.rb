require 'spec_helper'

describe CategoriesController do
	login_user

	describe 'GET #show' do
		context "with valid request" do
			it "finds the requested category" do
				category = create(:category)
				get :show, id: category.id
				expect(assigns(:category)).to eq category
			end
		end

		context "with invalid request" do
			it "redirects to home" do
				get :show, id: 1
				expect(response).to redirect_to home_path
			end
		end
	end
end
