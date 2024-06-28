class Minute < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :members, through: :attendances
end
