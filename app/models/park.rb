class Park < ApplicationRecord
  belongs_to :user
  has_many :events
  has_one_attached :park_image

  with_options presence: true do
    validates :prefecture_id
    validates :city
    validates :street
    validates :name
    validates :unit_price
  end

  validate :start_end_check
  validate :start_check

  def start_end_check
    errors.add(:end_time, "は開始時刻より遅い時間を選択してください") if self.start_time >= self.end_time
  end
  def start_check
    errors.add(:start_time, "は現在の日時より遅い時間を選択してください") if self.start_time < Time.now
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :prefecture_id, numericality: { other_than: 1 }
end
