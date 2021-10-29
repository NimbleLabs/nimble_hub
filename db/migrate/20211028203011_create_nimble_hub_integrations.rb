class CreateNimbleHubIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :nimble_hub_integrations do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.string :access_token
      t.string :access_token_secret
      t.string :refresh_token
      t.integer :token_expires_in
      t.datetime :token_expires_at
      t.jsonb :auth_info, null: true, default: '{}'
      t.jsonb :metadata, null: true, default: '{}'
      t.string :slug, index: true, unique: true

      t.timestamps
    end
  end
end
