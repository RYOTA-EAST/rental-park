class Event < ApplicationRecord
  belongs_to :park
  belongs_to :user
  belongs_to :car
end
