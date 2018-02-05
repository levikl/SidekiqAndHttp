require 'sidekiq'
require_relative 'http_connection'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class GetRequestSender
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in { 0 }

  def perform(path, params={})
    # For exercise 3, replace this comment with code that
    # sends the request, parses the response, and uses `puts` to
    # print the message part of the response
    response = HttpConnection.get(path, { body: params })
    puts JSON.parse(response.parsed_response)["message"]

    # For exercise 5, replace this comment with code that
    # retries the request if it fails
    raise if response.code != 200
  end
end
