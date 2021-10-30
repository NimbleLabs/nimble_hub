require 'httparty'

module NimbleHub
  class OauthCallbacksController < ApplicationController

    def oauth_callback
      begin
        provider = params[:provider]

        if provider == 'twitter'
          oauth_token = params["oauth_token"]
          oauth_verifier = params["oauth_verifier"]
          @user = current_user
          @service = NimbleHub::Tweets::OauthService.new(oauth_token, oauth_verifier, @user)
          @integration = @service.process_oauth

          if @user.blank?
            sign_in_and_redirect @integration.user, event: :authentication #this will throw if @user is not
            return
          end

          # NimbleHub::LoadTwitterJob.perform_later
        end

        redirect_to integrations_path
      end
    end

  end
end