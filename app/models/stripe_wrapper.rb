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

  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        StripeWrapper.set_api_key
        response = Stripe::Customer.create(
          :source => options[:source],
          :plan => "premium",
          :email => options[:user].email
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def success?
      response.present?
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['stripe_api_key']
  end
end