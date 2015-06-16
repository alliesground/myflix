require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST #create' do
    before { ActionMailer::Base.deliveries.clear }

    context "when users email is present in the database" do
      let(:jane) { create(:user, email:'jane@example.com') }
      it "sends email" do
        post :create, email: jane.email
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      it "send email to the right user" do
        post :create, email: jane.email
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq([jane.email])
      end

      it "sends email with a link to the password reset page" do
        post :create, email: jane.email
        message = ActionMailer::Base.deliveries.last
        expect(message.body.encoded).to match("http://localhost/reset_password/#{jane.token}")
      end
    end

    context "when users email is not present in the database" do
      it "does not send the email" do
        post :create, email: 'unknown@example.com'
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET #edit' do
    it "sets @token with the user token" do
      user = create(:user)
      get :edit, id: user.token
      expect(assigns(:token)).to eq user.token
    end
  end

  describe 'PATCH #update' do
    context "with valid token" do
      let(:user) { create(:user, password: 'old_password') }

      it "updates user password" do
        patch :update, new_password: 'new_password', token: user.token
        expect(user.reload.authenticate('new_password')).to be_truthy
      end

      it "updates token value" do
        user.update_column(:token, 'abcd')
        patch :update, new_password: 'new_password', token: user.token
        expect(user.reload.token).to_not eq 'abcd'
      end

      it "redirects to the login path" do
        patch :update, new_password: 'new_password', token: user.token
        expect(response).to redirect_to login_path
      end
    end

    context "with invalid token" do
      it "redirects to expired token page" do
        user = create(:user)
        patch :update, token: 123
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end