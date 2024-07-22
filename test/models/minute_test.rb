require "test_helper"

class MinuteTest < ActiveSupport::TestCase
  test "#meeting_was_already_held?" do
    course = Course.find_by(name: "Railsエンジニアコース")
    minute = course.minutes.create(date: Time.zone.parse('2024-07-03'), next_date: Time.zone.parse('2024-07-17'))

    travel_to Time.zone.parse('2024-07-02') do
      refute minute.meeting_was_already_held?
    end

    travel_to Time.zone.parse('2024-07-03') do
      refute minute.meeting_was_already_held?
    end

    travel_to Time.zone.parse('2024-07-04') do
      assert minute.meeting_was_already_held?
    end
  end

  test "#meeting_is_today?" do
    course = Course.find_by(name: "Railsエンジニアコース")
    minute = course.minutes.create(date: Time.zone.parse('2024-07-03'), next_date: Time.zone.parse('2024-07-17'))

    travel_to Time.zone.parse('2024-07-02') do
      refute minute.meeting_is_today?
    end

    travel_to Time.zone.parse('2024-07-03') do
      assert minute.meeting_is_today?
    end

    travel_to Time.zone.parse('2024-07-04') do
      refute minute.meeting_is_today?
    end
  end
end
