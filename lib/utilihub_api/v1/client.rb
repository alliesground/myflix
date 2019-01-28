module UtilihubAPI
  module V1
    class Client
      attr_reader :response, :status

      API_ENDPOINT = "https://#{ENV['utilihub_api_url']}/campaigns".freeze
      AUTH_KEY = ENV['utilihub_api_auth_key'].freeze

      def successful_request?
      end

      private

      def client
#        @client ||= Faraday.new(API_ENDPOINT) do |client|
#          client.request :url_encoded
#          client.adapter Faraday.default_adapter
#          client.headers['Authorization'] = "Basic #{AUTH_KEY}"
#        end
      end

      def request(http_method: nil, endpoint: nil)
        @response = {
          company_id: 'Company123',
          partner_code: 'tree',
          partner_admin_account: 'admin@mycompany.com.au',
          partner_admin_id: 12345,
          name: 'sam',
          age: 34,
          status: 201
        }
#        @response = client.public_send(http_method, endpoint)
         return response if success?

#        check_status(response)
        #p parse_json(response)
      end

      def parse_json(response)
        JSON.parse(response.body)
      end

      def check_status(response)
        p 'checking status and raise error'

        case response[:status]
        when 201 #POST created
          self.status = :created
          self.response = response
        when 200
          self.status = :ok
        end
      end
    end
  end
end
