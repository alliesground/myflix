require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge" do
        Stripe.api_key = ENV['stripe_api_key']

        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 6,
            :exp_year => 2016,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          currency: "usd",
          source: token
        )

        expect(response).to be_success
      end

      it "generates a card declined error" do
        Stripe.api_key = ENV['stripe_api_key']

        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 6,
            :exp_year => 2016,
            :cvc => "314"
          }
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          currency: 'usd',
          source: token
        )

        expect(response.status).to eq :error
        expect(response).to_not be_success
      end
    end
  end
end