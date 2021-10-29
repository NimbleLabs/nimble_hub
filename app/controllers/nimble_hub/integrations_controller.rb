require_dependency "nimble_hub/application_controller"

module NimbleHub
  class IntegrationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_integration, only: [:show, :edit, :update, :destroy]

    # GET /integrations
    def index
      @integrations = current_user.integrations
    end

    # GET /integrations/1
    def show
    end

    # DELETE /integrations/1
    def destroy
      @integration.destroy
      redirect_to integrations_url, notice: 'Integration was successfully destroyed.'
    end

    def setup
      if params[:provider] == 'tweets'
        redirect_to NimbleHub::Tweets::OauthService.authorize_url
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_integration
      @integration = Integration.find(params[:id])
    end

  end
end
