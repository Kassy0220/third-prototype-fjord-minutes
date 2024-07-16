class MeetingSecretary
  class << self
    def prepare_for_meeting
      Rails.logger.info('prepare_for_meeting executed')
      # TODO: フロントエンドコースでも作成できるようにする
      course = Course.first
      prepare course
    end

    private
    def prepare(course)
      create_minute(course)
      # TODO: ミーティング開催日の通知処理を追加
    end

    def create_minute(course)
      latest_minute = course.minutes.order(:created_at).last
      unless meeting_was_held_yesterday?(latest_minute)
        Rails.logger.info("create_minute wasn't executed #{{ 'course' => course.name }}")
        return
      end

      meeting_date = latest_minute.next_date
      next_meeting_date = calc_next_meeting_date(meeting_date, course)
      title = "ふりかえり・計画ミーティング#{meeting_date.strftime('%Y年%m月%d日')}"

      new_minute = course.minutes.create!(title:, date: meeting_date, next_date: next_meeting_date)
      Rails.logger.info("create_minute executed #{{ 'course' => course.name, new_minute_id: new_minute.id }}")
      # TODO: 議事録作成時の通知処理を追加
    end

    def meeting_was_held_yesterday?(minute)
      minute.date == Time.zone.yesterday
    end

    def calc_next_meeting_date(date, course)
      week_of_month = calc_week_of_month(date)

      week_of_month <= 2 ? date + 2.weeks : next_month_meeting_date(date, course)
    end

    def calc_week_of_month(date)
      all_wednesdays = all_wednesdays_of_month(date.year, date.month)
      all_wednesdays.index(date.day) + 1
    end

    def next_month_meeting_date(date, course)
      next_month = date.month <= 11 ? date.month + 1 : 1
      year = date.month <= 11 ? date.year : date.year + 1

      all_wednesdays_of_next_month = all_wednesdays_of_month(year, next_month)
      course.odd_meeting_week? ?
        Time.zone.local(year, next_month, all_wednesdays_of_next_month.first)
        : Time.zone.local(year, next_month, all_wednesdays_of_next_month.second)
    end

    def all_wednesdays_of_month(year, month)
      wednesdays = []

      first_day = Date.new(year, month, 1)
      last_day = Date.new(year, month, -1)

      current_day = first_day
      current_day += 1 until current_day.wday == 3

      while current_day <= last_day
        wednesdays << current_day.day
        current_day += 7
      end

      wednesdays
    end
  end
end
