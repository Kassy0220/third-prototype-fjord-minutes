class Course < ApplicationRecord
  enum :meeting_week, %i(odd even), suffix: true

  has_many :minutes
  has_many :members
end
