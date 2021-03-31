FactoryBot.define do
  factory :car do
    vehicle_type { Faker::Vehicle.model }
    city { '名古屋' }
    class_number { Faker::Number.number(digits: 3) }
    registration_type { 'あ' }
    designated_number { Faker::Number.number(digits: 4) }
    use_stop { false }
    association :user

    after(:build) do |car|
      car.vehicle_image.attach(io: File.open('public/images/vehicle.jpeg'), filename: 'vehicle.jpeg')
      car.number_image.attach(io: File.open('public/images/number.jpeg'), filename: 'number.jpeg')
    end
  end
end
