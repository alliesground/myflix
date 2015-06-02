require 'spec_helper'

describe SessionsController do
  describe "POST #create" do
    let(:user){ create(:user) }
    it "logs in user with valid attributes" do
      post :create, email: user.email, password: 'wildhorses'
      expect(session[:user_id]).to eq user.id
    end

    it "renders :new template for invalid email" do
      post :create, email: 'invalid@example.com', password: 'wildhorses'
      expect(response).to render_template :new
    end

    it "renders :new template for invalid password" do
      post :create, email: user.email, password: 'wildroses'
      expect(response).to render_template :new
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