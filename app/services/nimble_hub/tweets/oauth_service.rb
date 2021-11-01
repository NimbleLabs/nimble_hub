require 'oauth'

class NimbleHub::Tweets::OauthService

  def initialize(oauth_token, oauth_verifier, user)
    @oauth_token = oauth_token
    @oauth_verifier = oauth_verifier
    @user = user
    @baseUrl = 'https://api.twitter.com/oauth/access_token'
  end

  def process_oauth
    response = HTTParty.post(@baseUrl + "?oauth_token=#{@oauth_token}&oauth_verifier=#{@oauth_verifier}" )
    response_data = response.split("&")
    @access_token = parse_token_data(response_data, 'oauth_token=' )
    @access_secret = parse_token_data(response_data, 'oauth_token_secret=' )
    @twitter_user_id = parse_token_data(response_data, 'user_id=' )
    @screen_name = parse_token_data(response_data, 'screen_name=' )

    if @user.blank?

      @service = NimbleHub::Tweets::TwitterService.new(@access_token, @access_secret)
      @user_profile = @service.profile

      @user = User.find_by_email(@user_profile.email)

      if @user.blank?
        user_params = {
          name: @user_profile.name,
          email: @user_profile.email,
          password: Devise.friendly_token[0, 20],
          image_url: @user_profile.profile_image_uri_https(:original).to_s
        }
        @user = User.create(user_params)

        if @user.errors.any?
          puts '*****************************'
          puts 'Boom!'
        end

      end


    end

    integration = NimbleHub::Integration.where({user_id: @user.id, name: 'Twitter'}).first_or_create
    integration.access_token = @access_token
    integration.access_token_secret = @access_secret
    integration.auth_info = {twitter_user_id: @twitter_user_id, screen_name: @screen_name}

    if !integration.save
      Rails.logger.info('Integration saved')
    else
      Rails.logger.error("Error saving integration: #{integration.errors.full_messages.inspect}")
    end

    integration
  end

  def self.authorize_url

    oauth_options = {
      site: 'https://api.twitter.com',
      authorize_path: '/oauth/authenticate',
      debug_output: false
    }

    consumer = OAuth::Consumer.new(ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'],oauth_options)
    callback_url = ENV['OAUTH_REDIRECT_URI'] + 'twitter'
    request_token = consumer.get_request_token(:oauth_callback => callback_url)
    token = request_token.token
    confirmed = request_token.params["oauth_callback_confirmed"]

    if confirmed != "true"
      # TODO: log an error here!
      return integrations_path
    end

    "https://api.twitter.com/oauth/authorize?oauth_token=#{token}"
  end

  private

  def parse_token_data(tokens, token_name)
    tokens.each do |token|
      return token.split("=")[1] if token.index(token_name).present?
    end
  end

end
