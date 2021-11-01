module NimbleHub
  class DataSource < ApplicationRecord
    extend FriendlyId
    friendly_id :name_and_type, use: [:slugged, :finders]

    belongs_to :user

    validates_presence_of :name
    validates_presence_of :source_type
    validates_uniqueness_of :name, scope: [:source_type, :user_id]

    before_validation :on_before_validation

    def on_before_validation
      if self.uuid.blank?
        self.uuid = (0...12).map {(65 + rand(26)).chr}.join
      end
    end

    def table_name
      "#{source_type}#{name}"
    end

    def name_and_type
      "#{source_type} #{name}"
    end

  end
end
