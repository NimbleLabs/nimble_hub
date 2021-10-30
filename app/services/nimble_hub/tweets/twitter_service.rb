require_dependency "twitter/base"
require_dependency "twitter/rest/client"

module NimbleHub
  module Tweets
    class TwitterService
      def initialize(access_token, access_secret)
        @access_token = access_token
        @access_secret = access_secret

        @client = Twitter::REST::Client.new do |config|
          config.consumer_key = ENV['TWITTER_KEY']
          config.consumer_secret = ENV['TWITTER_SECRET']
          config.access_token = @access_token
          config.access_token_secret = @access_secret
        end
      end

      def profile
        @client.verify_credentials(include_email: true)
      end
    end
  end
end