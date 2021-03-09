class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  has_many :parks

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

  validates :prefecture_code, numericality: { other_than: 1 }


end
