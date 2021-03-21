class Park < ApplicationRecord
  belongs_to :user
  has_many :events
  has_one_attached :park_image
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :prefecture_id, numericality: { other_than: 1 }
end
