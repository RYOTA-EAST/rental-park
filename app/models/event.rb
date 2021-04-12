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
    errors.add(:end_date, 'は開始時刻より遅い時間を選択してください') if id.nil? && !(start_date.nil? || end_date.nil?) && (start_date >= end_date)
  end

  def start_check
    errors.add(:start_date, 'は現在の日時より遅い時間を選択してください') if id.nil? && !start_date.nil? && (start_date < Time.now)
  end

  def start_date_within_period
    if id.nil? && !(start_date.nil? || end_date.nil?) && (start_date < park.start_time || start_date > park.end_time)
      errors.add(:start_date, 'は期間内を選択してください')
    end
  end

  def end_date_within_period
    if id.nil? && !(start_date.nil? || end_date.nil?) && (end_date < park.start_time || end_date > park.end_time)
      errors.add(:end_date, 'は期間内を選択してください')
    end
  end
end
