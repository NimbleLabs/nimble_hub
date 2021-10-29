require_dependency "twitter/base"
require_dependency "twitter/rest/client"

module NimbleHub
  module Tweets
    class LoadService

      def run
        @user = User.first
        @factory = NimbleHub::Tweets::DataSourceFactory.new(@user)
        @factory.create_data_sources unless @factory.data_sources?
        @client = Twitter::REST::Client.new do |config|
          config.consumer_key = ENV['TWITTER_KEY']
          config.consumer_secret = ENV['TWITTER_SECRET']
        end
        load_user_data
      end

      def load_user_data
        seed_users = %w[harrisreynolds agazdecki DanielleMorrill jesterxl KateBour 5harath garrytan
        nocodedevs bentossell awilkinson thisiskp_ AndrewWarner Harris_Bryan tdinh_me]

        @growth_datasource = @factory.growth_datasource
        @user_datasource = @factory.user_datasource
        @growth_storage = NimbleHub::Mongo::StorageService.new(@growth_datasource)
        @user_storage = NimbleHub::Mongo::StorageService.new(@user_datasource)

        seed_users.each do |twitter_user|
          user_profile = @client.user(twitter_user)
          @growth_storage.create(growth_record(twitter_user, user_profile))
          save_user_record(twitter_user, user_profile)
        end
      end

      private

      def save_user_record(twitter_user, user_profile)
        record = user_record(twitter_user, user_profile)
        filter = { user_id: user_profile.id }

        if @user_storage.exists?(filter)
          @user_storage.update(filter, record)
        else
          @user_storage.create(record)
        end
      end

      def user_record(user_name, user_profile)
        {
          user: user_name,
          user_id: user_profile.id,
          followers: user_profile.followers_count,
          following: user_profile.friends_count,
          favorites: user_profile.favourites_count,
          tweets: user_profile.statuses_count,
          description: user_profile.description,
          website: user_profile.website,
          location: user_profile.location,
          image_url: user_profile.profile_image_uri_https(:original),
          created_at: user_profile.created_at,
          date: Date.today
        }
      end

      def growth_record(user_name, user_profile)
        {
          user: user_name,
          followers: user_profile.followers_count,
          following: user_profile.friends_count,
          date: Date.today
        }
      end
    end
  end
end
