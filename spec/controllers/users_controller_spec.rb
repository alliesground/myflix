require 'spec_helper'

describe UsersController do
	describe 'POST #create' do
		context "with valid attributes" do
			it "saves the new user" do
				expect{
					post :create, user: attributes_for(:user)
				}.to change(User, :count).by(1)
			end
		end
		context "with invalid attributes" do
			it "does not save a new user" do
				expect{
					post :create, user: attributes_for(:invalid_user)
				}.to_not change(User, :count)
			end

			it "renders the :new template" do
				post :create, user: attributes_for(:invalid_user)
				expect(response).to render_template :new
			end
		end
	end
end