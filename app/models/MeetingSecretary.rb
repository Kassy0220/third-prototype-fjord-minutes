class MeetingSecretary
  @day_of_the_week_for_meeting = { '日曜日' => 0, '月曜日' => 1, '火曜日' => 2, '水曜日' => 3, '木曜日' => 4, '金曜日' => 5, '土曜日' => 6 }['水曜日']

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
      unless latest_minute.meeting_was_already_held?
        Rails.logger.info("create_minute wasn't executed #{{ 'course' => course.name }}")
        return
      end

      meeting_date = latest_minute.next_date
      next_meeting_date = calc_next_meeting_date(meeting_date, course)
      title = "ふりかえり・計画ミーティング#{meeting_date.strftime('%Y年%m月%d日')}"

      new_minute = course.minutes.create!(title:, date: meeting_date, next_date: next_meeting_date)
      Rails.logger.info("create_minute executed #{{ 'course' => course.name, new_minute_id: new_minute.id }}")
      Discord::Notifier.message(NotificationMessageTemplate.create_message(:create, course, new_minute)) if new_minute
    end

    def calc_next_meeting_date(date, course)
      date.day <= 14 ? date + 2.weeks : next_month_meeting_date(date, course)
    end

    def next_month_meeting_date(date, course)
      year = date.month <= 11 ? date.year : date.year + 1
      next_month = date.month <= 11 ? date.month + 1 : 1

      meeting_days = all_meeting_days_in_month(year, next_month)
      course.odd_meeting_week? ?
        Time.zone.local(year, next_month, meeting_days.first)
        : Time.zone.local(year, next_month, meeting_days.second)
    end

    def all_meeting_days_in_month(year, month)
      meeting_days = []

      first_day = Date.new(year, month, 1)
      last_day = first_day.end_of_month

      meeting_day = first_day
      meeting_day += 1 until meeting_day.wday == @day_of_the_week_for_meeting

      while meeting_day <= last_day
        meeting_days << meeting_day.day
        meeting_day += 7
      end

      meeting_days
    end
  end
end
