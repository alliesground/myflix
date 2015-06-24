require 'spec_helper'

describe InvitationsController do
  describe 'GET #new' do
    login_user
    it "sets @invitation as an instance of Invitation" do
      get :new
      expect(assigns(:invitation)).to be_an_instance_of Invitation
    end
  end

  describe 'POST #create' do
    context "with authenticated user" do
      login_user

      context "with valid input" do
        before :each do
          post :create, invitation: {recipient_name:'james', recipient_email:'james@example.com', message:'please join myflix'}
        end

        it "redrects to the invite page" do
          expect(response).to redirect_to invite_path
        end

        it "creates an invitation" do
          expect(Invitation.count).to eq 1
        end

        it "sends invitation email to the recipient" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends email with a link to registration page" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to have_link 'Register'
        end
      end

      context "with invalid input" do
        it "renders :new template" do
          post :create, invitation: {recipient_name:'james', recipient_email: nil, message:'please join myflix'}
          expect(response).to render_template :new
        end
      end
    end

    context "with unauthenticated user" do
      it_behaves_like 'require sign in' do
        let(:action) { post :create, name:'james', email:'james@example.com', message:'please join myflix' }
      end
    end
  end
end