FactoryBot.define do
  factory :park do
    prefecture_id { 2 }
    address = Gimei.unique.address
    city { address.city.kanji }
    street { address.town.kanji }
    explosive { 'XYZビル' }
    name { 'ABC駐車場' }
    unit_price { Faker::Number.between(from: 50, to: 500) }
    start_time { Faker::Time.between(from: DateTime.now + 1.hour, to: DateTime.now + 3.hour).ceil_to(15.minutes) }
    end_time { Faker::Time.between(from: start_time + 4.hour, to: DateTime.now + 10).ceil_to(15.minutes) }
    rending_stop { false }

    association :user

    after(:build) do |park|
      park.park_image.attach(io: File.open('public/images/park.png'), filename: 'park.png')
    end
  end
end
