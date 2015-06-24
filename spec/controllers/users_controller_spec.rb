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
    context "with normal registration" do
      context "with valid attributes" do
        context "with successful charge" do
          successful_stripe_charge
          before { post :create, user: attributes_for(:user) }

          it_behaves_like "charged registered user"

          it "creates the user" do
            expect(User.count).to eq 1
          end
        end

        context "with unsuccessful charge" do
          unsuccessful_stripe_charge
          before { post :create, user: attributes_for(:user) }

          it_behaves_like "user with unsuccessful charge"

          it "does not create a user" do
            expect(User.count).to eq 0
          end
        end
      end
    end

    context "registration for invited user" do
      let(:alice) { create(:user) }
      let(:invitation) { create(:invitation, inviter: alice, recipient_email: 'john@example.com') }

      context "with valid attributes" do
        context "with successful charge" do
          successful_stripe_charge
          before :each do
            post :create, user: attributes_for(:user, email: 'john@example.com'), invitation_token: invitation.token
          end

          it_behaves_like "charged registered user"

          it "creates the user" do
            expect(User.count).to eq 2
          end

          it "creates a relationship between the inviter and recipient" do
            expect(Relationship.count).to eq 1
          end

          it "expires the invitation after acceptance" do
            expect(Invitation.first.reload.token).to be_nil
          end
        end

        context "with unsuccessful charge" do
          unsuccessful_stripe_charge
          before :each do
            post :create, user: attributes_for(:user, email: 'john@example.com'), invitation_token: invitation.token
          end

          it_behaves_like "user with unsuccessful charge"

          it "does not create a user" do
            expect(User.count).to eq 1
          end
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