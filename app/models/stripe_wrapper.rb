module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        StripeWrapper.set_api_key
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: options[:currency],
          source: options[:source]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def success?
      status == :success
    end

    def error_message
      response.message
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['stripe_api_key']
  end
end