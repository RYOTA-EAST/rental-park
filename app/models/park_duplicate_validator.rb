class ParkDuplicateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 新規登録する期間
    new_start_time = record.start_time
    new_end_time   = record.end_time

    return unless new_start_time.present? && new_end_time.present?

    # 重複する期間を検索(編集時は自期間を除いて検索)
    if record.id.present?
      not_own_periods = Event.where(park_id: record.id, cancel_flag: false).where('start_date < ? OR end_date > ?', new_start_time, new_end_time)
    end

    record.errors.add(attribute, 'に重複があります') if not_own_periods.present?
  end
end