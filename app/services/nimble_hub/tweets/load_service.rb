require_dependency "twitter/base"
require_dependency "twitter/rest/client"

module NimbleHub
  module Tweets
    class LoadService

      def run
        starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @user = User.first
        @factory = NimbleHub::Tweets::DataSourceFactory.new(@user)
        @factory.create_data_sources unless @factory.data_sources?
        @client = Twitter::REST::Client.new do |config|
          config.consumer_key = ENV['TWITTER_KEY']
          config.consumer_secret = ENV['TWITTER_SECRET']
        end
        load_user_data

        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        elapsed = ending - starting
        puts "Time elapsed: #{elapsed}"
      end

      def load_user_data
        # seed_users = %w[harrisreynolds agazdecki DanielleMorrill jesterxl KateBour 5harath garrytan
        # nocodedevs bentossell awilkinson thisiskp_ AndrewWarner Harris_Bryan tdinh_me]

        seed_users = %w[harrisreynolds agazdecki]
        @growth_datasource = @factory.growth_datasource
        @user_datasource = @factory.user_datasource
        @growth_storage = NimbleHub::Mongo::StorageService.new(@growth_datasource)
        @user_storage = NimbleHub::Mongo::StorageService.new(@user_datasource)

        seed_users.each do |twitter_user|
          user_profile = @client.user(twitter_user)
          @growth_storage.create(growth_record(twitter_user, user_profile))
          save_user_record(twitter_user, user_profile)
        end

        @growth_storage.close
        @user_storage.close

        puts '***********************************************'
        puts 'About to save tweets'
        puts '***********************************************'

        seed_users.each do |twitter_user|
          load_tweets(twitter_user)
        end
      end

      private

      def load_tweets(twitter_user)

        total_processed = 0
        min_id = nil

        options = {count: 200, include_rts: true}
        tweets = @client.user_timeline(twitter_user, options)

        while !tweets.empty? || total_processed < 3200

          tweets.each do |tweet|

            if min_id.nil?
              min_id = tweet.id
            end

            if tweet.id < min_id
              min_id = tweet.id
            end

            save_tweet_record(twitter_user, tweet)
          end

          total_processed += tweets.length
          options = {count: 200, include_rts: true, max_id: min_id}
          tweets = @client.user_timeline(twitter_user, options)
        end

        puts 'Finished processing for ' + twitter_user
      end

      def save_tweet_record(twitter_user, tweet)
        puts 'Saving tweet'

        @tweet_datasource = @factory.tweet_datasource
        @tweet_storage = NimbleHub::Mongo::StorageService.new(@tweet_datasource)
        record = tweet_record(twitter_user, tweet)
        filter = { tweet_id: tweet.id }

        if @tweet_storage.exists?(filter)
          @tweet_storage.update(filter, record)
        else
          @tweet_storage.create(record)
        end
      end

      def save_user_record(twitter_user, user_profile)
        record = user_record(twitter_user, user_profile)
        filter = { user_id: user_profile.id }

        if @user_storage.exists?(filter)
          @user_storage.update(filter, record)
        else
          @user_storage.create(record)
        end
      end

      def tweet_record(user_name, tweet)
        {
          user: user_name,
          tweet_id: tweet.id,
          tweet: tweet.text,
          favorite_count: tweet.favorite_count.nil? ? 0 : tweet.favorite_count,
          quote_count: tweet.quote_count.nil? ? 0 : tweet.quote_count,
          reply_count: tweet.reply_count.nil? ? 0 : tweet.reply_count,
          retweet_count: tweet.retweet_count.nil? ? 0 : tweet.retweet_count,
          created_at: tweet.created_at
        }
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
          website: user_profile.website.to_s,
          location: user_profile.location,
          image_url: user_profile.profile_image_uri_https(:original).to_s,
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
