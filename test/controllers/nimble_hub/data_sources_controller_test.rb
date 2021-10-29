require "test_helper"

module NimbleHub
  class DataSourcesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @data_source = nimble_hub_data_sources(:one)
    end

    test "should get index" do
      get data_sources_url
      assert_response :success
    end

    test "should get new" do
      get new_data_source_url
      assert_response :success
    end

    test "should create data_source" do
      assert_difference('DataSource.count') do
        post data_sources_url, params: { data_source: { metadata: @data_source.metadata, name: @data_source.name, source_type: @data_source.source_type, user_id: @data_source.user_id, uuid: @data_source.uuid } }
      end

      assert_redirected_to data_source_url(DataSource.last)
    end

    test "should show data_source" do
      get data_source_url(@data_source)
      assert_response :success
    end

    test "should get edit" do
      get edit_data_source_url(@data_source)
      assert_response :success
    end

    test "should update data_source" do
      patch data_source_url(@data_source), params: { data_source: { metadata: @data_source.metadata, name: @data_source.name, source_type: @data_source.source_type, user_id: @data_source.user_id, uuid: @data_source.uuid } }
      assert_redirected_to data_source_url(@data_source)
    end

    test "should destroy data_source" do
      assert_difference('DataSource.count', -1) do
        delete data_source_url(@data_source)
      end

      assert_redirected_to data_sources_url
    end
  end
end
