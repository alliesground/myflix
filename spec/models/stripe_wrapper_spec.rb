require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 6,
        :exp_year => 2017,
        :cvc => "314"
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 6,
        :exp_year => 2016,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge" do
        Stripe.api_key = ENV['stripe_api_key']

        response = StripeWrapper::Charge.create(
          amount: 999,
          currency: "usd",
          source: valid_token
        )

        expect(response).to be_success
      end

      it "generates a card declined error" do
        Stripe.api_key = ENV['stripe_api_key']

        response = StripeWrapper::Charge.create(
          amount: 999,
          currency: 'usd',
          source: invalid_token
        )

        expect(response.status).to eq :error
        expect(response).to_not be_success
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      let(:user) { build(:user) }
      it "creates a customer with valid card" do
        Stripe.api_key = ENV['stripe_api_key']

        # Create a Customer
        response = StripeWrapper::Customer.create(
          :source => valid_token,
          :user => user
        )

        expect(response).to be_success
      end

      it "does not create a customer with invalid card" do
        Stripe.api_key = ENV['stripe_api_key']

        # Create a Customer
        response = StripeWrapper::Customer.create(
          :source => invalid_token,
          :user => user
        )

        expect(response).to_not be_success
      end

      it "returns error message with declined card" do
        Stripe.api_key = ENV['stripe_api_key']

        # Create a Customer
        response = StripeWrapper::Customer.create(
          :source => invalid_token,
          :user => user
        )
        expect(response.error_message).to eq "Your card was declined."
      end
    end
  end
end