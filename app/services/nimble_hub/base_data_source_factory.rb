class NimbleHub::BaseDataSourceFactory

  def initialize(user)
    @user = user
  end

  def create_data_source(resource_name, source_type)
    NimbleHub::DataSource.where(name: resource_name, source_type: source_type, user_id: @user.id).first_or_create
  end

  def data_source(resource_name, source_type)
    NimbleHub::DataSource.where(name: resource_name, source_type: source_type, user_id: @user.id).first
  end

  def data_source?(resource_name, source_type)
    NimbleHub::DataSource.where(name: resource_name, source_type: source_type).first.present?
  end

end