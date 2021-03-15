class Car < ApplicationRecord
  belongs_to :user
  has_many :parks
  has_many :events
  has_one_attached :number_image
  has_one_attached :vehicle_image

end
