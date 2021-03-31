FactoryBot.define do
  factory :park do
    prefecture_id { 2 }
    address = Gimei.unique.address
    city { address.city.kanji }
    street { address.town.kanji }
    name { 'ABC駐車場' }
    unit_price { Faker::Number.between(from: 50, to: 500) }
    start_time { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 2) }
    end_time { Faker::Time.between(from: DateTime.now + 3, to: DateTime.now + 10) }
    rending_stop { false }

    association :user

    after(:build) do |park|
      park.park_image.attach(io: File.open('public/images/park.png'), filename: 'park.png')
    end
  end
end
