class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  has_many :parks
  has_many :cars
  has_many :events

  with_options presence: true do
    validates :nickname

    with_options presence: true, format: { with: /\A[ぁ-んァ-ヶ一-龥々]+\z/, message: 'は全角文字を使用してください' } do
      validates :first_name
      validates :last_name
    end

    with_options presence: true, format: { with: /\A[ァ-ヶ]+\z/, message: 'は全角カタカナを使用してください' } do
      validates :first_name_kana
      validates :last_name_kana
    end

    validates :postal_code, format: { with: /\A[0-9]{7}\z/, message: 'は半角数字を7文字入力してください' }
    validates :prefecture_id
    validates :city
    validates :street
    validates :phone_number, format: { with: /\A\d{1,11}\z/, message: 'は半角数字を11文字以内で入力してください' }
  end

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, message: 'には英字と数字の両方を含めて設定してください'

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  validates :prefecture_id, numericality: { other_than: 1 }
end
