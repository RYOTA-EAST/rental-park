class WithinPeriodValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 新規登録する期間
    new_start_date = record.start_date
    new_end_date   = record.end_date

    return unless new_start_date.present? && new_end_date.present?

    binding.pry
    # 重複する期間を検索(編集時は自期間を除いて検索)
    not_own_periods = if record.id.present?
                        Event.where('id NOT IN (?) AND start_date < ? AND end_date > ?', record.id, new_end_date, new_start_date)
                      else
                        Event.where('start_date < ? AND end_date > ?', new_end_date, new_start_date)
                      end

    record.errors.add(attribute, 'が借用期間内にありません') if not_own_periods.present?
  end
end
