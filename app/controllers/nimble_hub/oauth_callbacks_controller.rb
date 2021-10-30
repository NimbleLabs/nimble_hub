require 'httparty'

module NimbleHub
  class OauthCallbacksController < ApplicationController

    def oauth_callback
      begin
        provider = params[:provider]

        if provider == 'twitter'
          oauth_token = params["oauth_token"]
          oauth_verifier = params["oauth_verifier"]
          @service = NimbleHub::Tweets::OauthService.new(oauth_token, oauth_verifier, current_user)
          @service.process_oauth
          NimbleHub::LoadTwitterJob.perform_later
        end

        redirect_to integrations_path
      end
    end

  end
end