class Minute < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :members, through: :attendances
end
