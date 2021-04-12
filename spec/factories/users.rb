FactoryBot.define do
  factory :user do
    Gimei.unique.clear
    gimei = Gimei.unique.name
    address = Gimei.unique.address

    nickname { gimei.first.romaji }
    email { Faker::Internet.free_email }
    password = '1a' + Faker::Internet.password(min_length: 6)
    password { password }
    password_confirmation { password }
    last_name { gimei.last.kanji }
    first_name { gimei.first.kanji }
    last_name_kana { gimei.last.katakana }
    first_name_kana { gimei.first.katakana }
    postal_code { '1111111' }
    prefecture_id { 2 }
    city { address.city.kanji }
    street { address.town.kanji }
    explosive { 'メゾン夕張' }
    phone_number { '08022222222' }
  end
end
