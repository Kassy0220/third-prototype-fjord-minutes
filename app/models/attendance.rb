class Attendance < ApplicationRecord
  enum :time, [:day, :night, :absence]
  belongs_to :minute
  belongs_to :member
end
