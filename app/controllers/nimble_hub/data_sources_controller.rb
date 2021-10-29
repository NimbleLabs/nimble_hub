require_dependency "nimble_hub/application_controller"

module NimbleHub
  class DataSourcesController < ApplicationController
    before_action :set_data_source, only: [:show, :edit, :update, :destroy]

    # GET /data_sources
    def index
      @data_sources = DataSource.all
    end

    # GET /data_sources/1
    def show
    end

    # GET /data_sources/new
    def new
      @data_source = DataSource.new
    end

    # GET /data_sources/1/edit
    def edit
    end

    # POST /data_sources
    def create
      @data_source = DataSource.new(data_source_params)

      if @data_source.save
        redirect_to @data_source, notice: 'Data source was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /data_sources/1
    def update
      if @data_source.update(data_source_params)
        redirect_to @data_source, notice: 'Data source was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /data_sources/1
    def destroy
      @data_source.destroy
      redirect_to data_sources_url, notice: 'Data source was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_data_source
        @data_source = DataSource.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def data_source_params
        params.require(:data_source).permit(:name, :uuid, :user_id, :source_type, :metadata)
      end
  end
end
