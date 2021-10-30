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

    return Mongo::Client.new(ENV['MONGO_URL'], options) if Rails.env.production?
    options[:database] = Rails.env.test? ? 'nimble_hub_test' : 'nimble_hubz_dev'
    Mongo::Client.new(['127.0.0.1:27017'], options)
  end

  def collection(collection_name)
    @client[collection_name.to_sym]
  end

  def close
    @client.close
  end
end