class CreateNimbleHubDataSources < ActiveRecord::Migration[6.1]
  def change
    create_table :nimble_hub_data_sources do |t|
      t.string :name
      t.string :uuid
      t.references :user, null: false, foreign_key: true
      t.string :source_type
      t.jsonb :metadata, null: true, default: '{}'
      t.string :slug, index: true, unique: true

      t.timestamps
    end
  end
end
