class Car < ApplicationRecord
  belongs_to :user
  has_many :parks
  has_many :events
  has_one_attached :number_image
  has_one_attached :vehicle_image

  with_options presence: true do
    validates :number_image
    validates :vehicle_image
    validates :vehicle_type
    validates :city
    validates :class_number, format: { with: /\A[0-9]{1,3}\z/, message: '3桁以下の半角数字を入力してください' }
    validates :registration_type, format: { with: /\A[あ-えか-さす-ふほ-をEHKMTY]{1}\z/, message: '適切なひらがな、半角英字を1文字入力してください' }
    validates :designated_number, format: { with: /\A[0-9]{1,4}\z/, message: '4桁以下の半角数字を入力してください' }
  end
end
