class NimbleHub::Tweets::DataSourceFactory < NimbleHub::BaseDataSourceFactory

  def initialize(user)
    super(user)
  end

  def create_data_sources
    create_tweet_datasource
    create_growth_datasource
    create_users_datasource
    system_datasource
  end

  def tweet_datasource
    data_source('Tweets', 'Twitter')
  end

  def growth_datasource
    data_source('Growth', 'Twitter')
  end

  def user_datasource
    data_source('Users', 'Twitter')
  end

  def data_sources?
    data_source?('Tweets', 'Twitter') &&
      data_source?('Growth', 'Twitter') &&
      data_source?('Users', 'Twitter')
  end

  def create_tweet_datasource
    column_metadata = [
      { name: 'user', type: 'string' },
      { name: 'tweet_id', type: 'string' },
      { name: 'tweet', type: 'string' },
      { name: 'favorite_count', type: 'integer' },
      { name: 'quote_count', type: 'integer' },
      { name: 'reply_count', type: 'integer' },
      { name: 'retweet_count', type: 'integer' },
      { name: 'created_at', type: 'datetime' }
    ]
    meta_data = { columns: column_metadata }
    tweet_datasource = create_data_source('Tweets', 'Twitter')
    tweet_datasource.update(metadata: meta_data)
    tweet_datasource
  end

  def create_growth_datasource
    column_metadata = [
      { name: 'user', type: 'string' },
      { name: 'followers', type: 'integer' },
      { name: 'following', type: 'integer' },
      { name: 'date', type: 'date' }
    ]

    growth_datasource = create_data_source('Growth', 'Twitter')
    growth_datasource.update(metadata: { columns: column_metadata })
    growth_datasource
  end

  def create_users_datasource
    column_metadata = [
      { name: 'user', type: 'string' },
      { name: 'user_id', type: 'integer' },
      { name: 'followers', type: 'integer' },
      { name: 'following', type: 'integer' },
      { name: 'favorites', type: 'integer' },
      { name: 'location', type: 'string' },
      { name: 'tweets', type: 'integer' },
      { name: 'created_at', type: 'datetime' },
      { name: 'description', type: 'string' },
      { name: 'website', type: 'string' },
      { name: 'image_url', type: 'string' }
    ]

    users_datasource = create_data_source('Users', 'Twitter')
    users_datasource.update(metadata: { columns: column_metadata })
    users_datasource
  end

  def system_datasource
    column_metadata = [
      { name: 'user', type: 'string' },
      { name: 'interests', type: 'array' }
    ]

    users_datasource = create_data_source('SystemUsers', 'Twitter')
    users_datasource.update(metadata: { columns: column_metadata })
    users_datasource
  end
end