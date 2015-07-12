require 'spec_helper'

describe UsersController do
  describe 'GET #new' do
    it "creates an instance of User model" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'GET #new_with_invitation_token' do
    it "sets @user with recipient's email" do
      invitation = create(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq invitation.recipient_email
    end

    it "redirects to expired token page for invalid token" do
      get :new_with_invitation_token, token: "123qwe"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe 'POST #create' do
    context "with successful sign up" do
      it "redirect to login page" do
        response = double(:response, successful?: true)
        UserSignup.any_instance.should_receive(:save_with_subscription).and_return(response)

        post :create, user: attributes_for(:user)
        expect(response).to redirect_to login_path
      end
    end

    context "with unsuccessful sign up" do
      it "renders :new template" do
        response = double(:response, successful?: false)
        response.should_receive(:error_message)
        UserSignup.any_instance.should_receive(:save_with_subscription).and_return(response)

        post :create, user: attributes_for(:user), stripeToken: '1234'

        expect(response).to render_template :new
      end

      it "sets flash error message" do
        response = double(:response, successful?: false, error_message: "This is an error message")
        UserSignup.any_instance.should_receive(:save_with_subscription).and_return(response)

        post :create, user: attributes_for(:user), stripeToken: '123456'

        expect(flash[:danger]).to be_present
      end
    end
  end

  describe 'GET #show' do
    it_behaves_like 'require sign in' do
      let(:user) { create(:user) }
      let(:action) { get :show, id: user.id }
    end

    context "with authenticated user" do
      login_user

      it "sets @user with the instance of the requested user" do
        james = create(:user, email: "james@example.com")
        get :show, id: james.id
        expect(assigns(:user)).to be_instance_of User
      end
    end
  end
end