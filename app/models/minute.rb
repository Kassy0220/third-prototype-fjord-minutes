class Minute < ApplicationRecord
  belongs_to :course
  has_many :topics, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :members, through: :attendances

  def day_attendees
    attendances.where(time: :day).includes(:member).pluck(:email)
  end

  def night_attendees
    attendances.where(time: :night).includes(:member).pluck(:email)
  end

  def absentees
    attendances.where(time: :absence).includes(:member).pluck(:email, :progress_report)
  end

  def meeting_was_already_held?
    date.before? Time.zone.today
  end

  def meeting_is_today?
    date == Time.zone.today
  end
end
