require 'spec_helper'

describe UsersController do
  describe 'GET #new' do
    it "creates an instance of User model" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new user" do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "saves the email attribute in lower case" do
        post :create, user: attributes_for(:user, email: 'USER@Email.Com')
        expect(assigns(:user).email).to eq 'user@email.com'
      end

      it "redirects to login page" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid attributes" do
      before :each do
        post :create, user: attributes_for(:invalid_user)  
      end

      it "does not save a new user" do
        expect(User.count).to eq 0
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
    end
  end
end