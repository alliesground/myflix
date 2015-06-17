require 'spec_helper'

describe InvitationsController do
  describe 'POST #create' do
    context "with authenticated user" do
      login_user
      context "with valid input" do
        before :each do
          post :create, name:'james', email:'james@example.com', message:'please join myflix'
        end

        it "sends invitation email to a friend" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends email with a link to registration page" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body.encoded).to match("http://localhost/register")
        end
      end

      context "with invalid input" do
        it "renders :new template" do
          post :create
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