class Event < ApplicationRecord
  belongs_to :park
  belongs_to :user
  belongs_to :car

  with_options presence: true do
    validates :memo
    validates :start_date, duplicate: true
    validates :end_date, duplicate: true
  end
  validate :start_end_check
  validate :start_check
  validate :start_date_within_period
  validate :end_date_within_period

  def start_end_check
    errors.add(:end_date, "は開始時刻より遅い時間を選択してください") if self.start_date >= self.end_date
  end
  def start_check
    errors.add(:start_dete, "は現在の日時より遅い時間を選択してください") if self.start_date < Time.now
  end
  def start_date_within_period
    errors.add(:start_dete, "は期間内を選択してください") if self.start_date < park.start_time || self.start_date > park.end_time
  end
  def end_date_within_period
    errors.add(:end_dete, "は期間内を選択してください") if self.end_date < park.start_time || self.end_date > park.end_time
  end
end
