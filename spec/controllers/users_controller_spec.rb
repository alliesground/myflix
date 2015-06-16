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

      context "when sending email" do
        before { ActionMailer::Base.deliveries.clear }

        context "with valid inputs" do
          before { post :create, user: attributes_for(:user, email: 'jack@example.com') }

          it "sends email to the registered user with valid inputs" do
            expect(ActionMailer::Base.deliveries).to_not be_empty
          end

          it "sends to the right user with valid inputs" do
            message = ActionMailer::Base.deliveries.last
            expect(message.to).to eq ['jack@example.com']
          end
        end

        it "does not send email with invalid inputs" do
          post :create, user: attributes_for(:invalid_user)
          expect(ActionMailer::Base.deliveries).to be_empty
        end
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