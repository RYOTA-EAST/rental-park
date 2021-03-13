class Car < ApplicationRecord
  belongs_to :user
  has_many :parks
end
