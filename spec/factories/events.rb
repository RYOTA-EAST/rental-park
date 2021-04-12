FactoryBot.define do
  factory :event do
    memo { 'test' }
    start_date {}
    end_date {}
    cancel_flag { false }

    association :user
    association :park
    association :car
  end
end
