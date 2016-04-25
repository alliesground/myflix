require 'spec_helper'

describe UserSignup do
  describe '#sign_up_with_subscription' do
    context "with valid input and successful customer creation" do
      let(:customer) { double(:customer, success?: true) }
      let(:user) { build(:user) }

      before :each do
        StripeWrapper::Customer.stub(:create).and_return(customer)
      end

      it "creates a user" do
        UserSignup.new(user).save_with_subscription('stripe_token', nil)
        expect(User.count).to eq 1
      end

      it "sends sign up notification" do
        UserSignup.new(user).save_with_subscription('stripe_token', nil)
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      context "with invited user" do
        let(:alice) { create(:user) }
        let(:invitation) { create(:invitation, inviter: alice, recipient_email: 'john@example.com') }

        it "handles invitation" do
          UserSignup.new(user).save_with_subscription('stripe_token', invitation.token)
          expect(user.following?(alice)).to be_truthy
        end
      end
    end

    context "with valid input and unsuccessful customer creation" do
      let(:customer) { double(:customer, success?: false, error_message: "Your card was declined.") }
      let(:user) { build(:user) }

      before :each do
        StripeWrapper::Customer.stub(:create).and_return(customer)
      end

      it "does not create a user" do
        UserSignup.new(user).save_with_subscription('stripe_token', nil)
        expect(User.count).to eq 0
      end
    end

    context "with invalid input" do
      let(:user) { build(:invalid_user) }
      before :each do
        UserSignup.new(user).save_with_subscription('stripe_token', nil)
      end

      it "does not create a user" do
        expect(User.count).to eq 0
      end

      it "does not create a stripe customer" do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "does not send email notification" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe '#save_with_payment' do
    context "with valid input and successful charge" do
      let(:charge) { double(:charge, success?: true) }
      let(:user) { build(:user) }
      before :each do
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "creates a user" do
        UserSignup.new(user).save_with_payment('stripe_token', nil)
        expect(User.count).to eq 1
      end

      it "sends sign up notification" do
        UserSignup.new(user).save_with_payment('stripe_token', nil)
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end

      context "with invitation" do
        let(:alice) { create(:user) }
        let(:invitation) { create(:invitation, inviter: alice, recipient_email: 'john@example.com') }

        it "handles invitation" do
          UserSignup.new(user).save_with_payment('stripe_token', invitation.token)
          expect(user.following?(alice)).to be_truthy
        end
      end
    end

    context "with valid input and unsuccessful charge" do
      let(:charge) { double(:charge, success?: false) }
      let(:user) { build(:user) }

      it "does not create a user" do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        expect(User.count).to eq 0
      end
    end

    context "with invalid input" do
      before :each do
        UserSignup.new(build(:invalid_user)).save_with_payment(
            'stripe_token', nil)
      end

      it "does not create a user" do
        expect(User.count).to eq 0
      end

      it "does not charge the card" do
        Stripe::Charge.should_not_receive(:create)
      end

      it "does not send out registration email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
