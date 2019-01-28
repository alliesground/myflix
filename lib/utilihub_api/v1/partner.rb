module UtilihubAPI
  module V1
    class Partner < Client
      def initialize(response, status)
      end
      def create
        response = request(
          http_method: :post,
          endpoint: "partners"
        )

        new(response, :created)
      end

      def created?
        if status
      end
    end
  end
end

partner = UtilihubAPI::V1::Partner.new.create
if partner.created?
  partner.partner_code
else
  flash = "#{partner.error_message}"
end

partner.success?

