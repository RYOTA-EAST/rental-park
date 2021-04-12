class Park < ApplicationRecord
  belongs_to :user
  has_many :events
  has_one_attached :park_image
  
  with_options presence: true do
    validates :prefecture_id
    validates :city
    validates :street
    validates :name
    validates :unit_price, numericality: {only_integer: true, message: 'は半角数字を入力してください'}
    validates :start_time, park_duplicate: true
    validates :end_time, park_duplicate: true
    validates :park_image
  end
  
  validate :start_end_check
  validate :start_check

  geocoded_by :address
  after_validation :geocode

  def address
    "%s %s"%([self.city,self.street])
  end
  
  def start_end_check
    if self.id.nil?
      unless start_time == nil || end_time == nil
        errors.add(:end_time, "は開始時刻より遅い時間を選択してください") if self.start_time >= self.end_time
      end
    end
  end
  def start_check
    if self.id.nil?
      unless start_time == nil
        errors.add(:start_time, "は現在の日時より遅い時間を選択してください") if self.start_time < Time.now
      end
    end
  end
  
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :prefecture_id, numericality: { other_than: 1 }
end
