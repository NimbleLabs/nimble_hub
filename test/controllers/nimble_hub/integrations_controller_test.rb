require "test_helper"

module NimbleHub
  class IntegrationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @integration = nimble_hub_integrations(:one)
    end

    test "should get index" do
      get integrations_url
      assert_response :success
    end

    test "should get new" do
      get new_integration_url
      assert_response :success
    end

    test "should create integration" do
      assert_difference('Integration.count') do
        post integrations_url, params: { integration: { access_token: @integration.access_token, auth_info: @integration.auth_info, metadata: @integration.metadata, name: @integration.name, refresh_token: @integration.refresh_token, token_expires_at: @integration.token_expires_at, token_expires_in: @integration.token_expires_in, user_id: @integration.user_id } }
      end

      assert_redirected_to integration_url(Integration.last)
    end

    test "should show integration" do
      get integration_url(@integration)
      assert_response :success
    end

    test "should get edit" do
      get edit_integration_url(@integration)
      assert_response :success
    end

    test "should update integration" do
      patch integration_url(@integration), params: { integration: { access_token: @integration.access_token, auth_info: @integration.auth_info, metadata: @integration.metadata, name: @integration.name, refresh_token: @integration.refresh_token, token_expires_at: @integration.token_expires_at, token_expires_in: @integration.token_expires_in, user_id: @integration.user_id } }
      assert_redirected_to integration_url(@integration)
    end

    test "should destroy integration" do
      assert_difference('Integration.count', -1) do
        delete integration_url(@integration)
      end

      assert_redirected_to integrations_url
    end
  end
end
