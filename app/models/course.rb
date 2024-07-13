class Course < ApplicationRecord
  enum :meeting_week, %i(odd even)

  has_many :minutes
end
