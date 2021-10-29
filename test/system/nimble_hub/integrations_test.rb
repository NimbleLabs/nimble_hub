require "application_system_test_case"

module NimbleHub
  class IntegrationsTest < ApplicationSystemTestCase
    setup do
      @integration = nimble_hub_integrations(:one)
    end

    test "visiting the index" do
      visit integrations_url
      assert_selector "h1", text: "Integrations"
    end

    test "creating a Integration" do
      visit integrations_url
      click_on "New Integration"

      fill_in "Access token", with: @integration.access_token
      fill_in "Auth info", with: @integration.auth_info
      fill_in "Metadata", with: @integration.metadata
      fill_in "Name", with: @integration.name
      fill_in "Refresh token", with: @integration.refresh_token
      fill_in "Token expires at", with: @integration.token_expires_at
      fill_in "Token expires in", with: @integration.token_expires_in
      fill_in "User", with: @integration.user_id
      click_on "Create Integration"

      assert_text "Integration was successfully created"
      click_on "Back"
    end

    test "updating a Integration" do
      visit integrations_url
      click_on "Edit", match: :first

      fill_in "Access token", with: @integration.access_token
      fill_in "Auth info", with: @integration.auth_info
      fill_in "Metadata", with: @integration.metadata
      fill_in "Name", with: @integration.name
      fill_in "Refresh token", with: @integration.refresh_token
      fill_in "Token expires at", with: @integration.token_expires_at
      fill_in "Token expires in", with: @integration.token_expires_in
      fill_in "User", with: @integration.user_id
      click_on "Update Integration"

      assert_text "Integration was successfully updated"
      click_on "Back"
    end

    test "destroying a Integration" do
      visit integrations_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Integration was successfully destroyed"
    end
  end
end
