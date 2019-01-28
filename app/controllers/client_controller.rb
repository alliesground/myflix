class ClientController < ApplicationController
  def index
    @clients = Client.all

    @clients.each do |client|
      make_http_request(client.id)
    end
  end
end
