class Park < ApplicationRecord
  belongs_to :user
  has_many :events
  has_one_attached :park_image
end
