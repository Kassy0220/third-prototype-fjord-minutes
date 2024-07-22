class Minute < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :members, through: :attendances

  def meeting_was_already_held?
    date.before? Time.zone.today
  end

  def meeting_is_today?
    date == Time.zone.today
  end
end
