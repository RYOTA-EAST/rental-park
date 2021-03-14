class Car < ApplicationRecord
  belongs_to :user
  has_many :parks
  has_one_attached :image
end
