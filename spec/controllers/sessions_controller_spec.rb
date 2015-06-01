require 'spec_helper'

describe SessionsController do
	describe "POST #create" do
		context "with valid attributes" do
			let(:user){ create(:user, email: 'user@example.com') }
			it "logs in the user" do
				post :create, email: user.email, password: 'wildhorses'
				expect(session[:user_id]).to eq user.id
			end
		end

		context "with invalid attributes" do
			it "renders the :new template" do
				post :create, session: {email: 'invalid@example.com', password:'wildroses'}
				expect(response).to render_template :new
			end
		end
	end

	describe "DELETE #destroy" do
		login_user

		it "logs out the user" do
			delete :destroy
			expect(session[:user_id]).to eq nil
		end

		it "redirects to the root path" do
			delete :destroy
			expect(response).to redirect_to root_path
		end
	end
end