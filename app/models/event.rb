class Event < ApplicationRecord
  belongs_to :park
  belongs_to :user
  belongs_to :car

  with_options presence: true do
    validates :memo
    validates :start_date
    validates :end_date
  end
  validate :start_end_check
  validate :start_check

  def start_end_check
    errors.add(:end_date, "は開始時刻より遅い時間を選択してください") if self.start_date >= self.end_date
  end
  def start_check
    errors.add(:start_dete, "は現在の日時より遅い時間を選択してください") if self.start_date < Time.now
  end
end
