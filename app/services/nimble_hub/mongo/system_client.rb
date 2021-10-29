require_dependency "mongo"
require_dependency "bson"

class NimbleHub::Mongo::SystemClient
  def initialize
    @client = get_client
  end

  def get_client
    options = {
        max_pool_size: 20
    }

    if Rails.env.production?
      return Mongo::Client.new(ENV['MONGO_URL'], options)
    end

    options[:database] = Rails.env.test? ? 'nimble_hub_test' : 'nimble_hub_dev'
    Mongo::Client.new(['127.0.0.1:27017'], options)
  end

  def collection(collection_name)
    @client[collection_name.to_sym]
  end

  def close
    @client.close
  end
end