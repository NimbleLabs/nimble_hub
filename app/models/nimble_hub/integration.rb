module NimbleHub
  class Integration < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: [:slugged, :finders]

    belongs_to :user

    validates_presence_of :name
  end
end
