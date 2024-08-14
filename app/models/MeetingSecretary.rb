class MeetingSecretary
  DAY_OF_THE_MEETING_FOR_MEETING = { '日曜日' => 0, '月曜日' => 1, '火曜日' => 2, '水曜日' => 3, '木曜日' => 4, '金曜日' => 5, '土曜日' => 6 }['水曜日']

  class << self
    def prepare_for_meeting
      Rails.logger.info('prepare_for_meeting executed')
      all_courses = Course.all
      all_courses.each { |course| prepare course }
    end

    private
    def prepare(course)
      exist_minute?(course) ? create_minute(course) : create_first_minute(course)
      notify_today_meeting(course)
    end

    def exist_minute?(course)
      course.minutes.exists?
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

      Discord::Notifier.message(NotificationMessageTemplate.create_message(:create, course, new_minute), url: webhook_url(course)) if new_minute
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
      meeting_day += 1 until meeting_day.wday == DAY_OF_THE_MEETING_FOR_MEETING

      while meeting_day <= last_day
        meeting_days << meeting_day.day
        meeting_day += 7
      end

      meeting_days
    end

    def create_first_minute(course)
      GithubWikiManager.new(course)
      working_directory = course.name == 'Railsエンジニアコース' ? GithubWikiManager::BOOTCAMP_WORKING_DIRECTORY
                                                               : GithubWikiManager::AGENT_WORKING_DIRECTORY

      latest_meeting_date = get_latest_meeting_date_from_cloned_minutes(working_directory)
      unless latest_meeting_date.before? Time.zone.today
        Rails.logger.info("create_first_minute wasn't executed #{{ 'course' => course.name }}")
        return
      end

      latest_minute_title = "ふりかえり・計画ミーティング#{latest_meeting_date.strftime('%Y年%m月%d日')}"
      latest_minute_content = File.open("#{working_directory}/#{latest_minute_title}.md") { |file| file.read }
      _, next_meeting_year, next_meeting_month, next_meeting_day = *latest_minute_content.match(/(\d{4})年(\d{2})月(\d{2})日[ 　]*\([日月火水木金土]\)/)

      meeting_date = Time.zone.local(next_meeting_year, next_meeting_month, next_meeting_day)
      next_meeting_date = calc_next_meeting_date(meeting_date, course)
      title = "ふりかえり・計画ミーティング#{meeting_date.strftime('%Y年%m月%d日')}"

      new_minute = course.minutes.create!(title:, date: meeting_date, next_date: next_meeting_date)
      Rails.logger.info("create_first_minute executed #{{ 'course' => course.name, new_minute_id: new_minute.id }}")
      Discord::Notifier.message(NotificationMessageTemplate.create_message(:create, course, new_minute), url: webhook_url(course)) if new_minute
    end

    def get_latest_meeting_date_from_cloned_minutes(working_directory)
      meeting_days = Dir.glob('ふりかえり・計画ミーティング*', base: working_directory).map do |filename|
        _, year, month, day = *filename.match(/ふりかえり・計画ミーティング(\d{4})年(\d{2})月(\d{2})/)
        Date.new(year.to_i, month.to_i, day.to_i)
      end

      meeting_days.sort.last
    end

    def notify_today_meeting(course)
      unless exist_minute?(course)
        Rails.logger.info("notify_today_meeting wasn't executed #{{ 'course' => course.name }}")
        return
      end

      latest_minute = course.minutes.order(:created_at).last
      if !latest_minute.meeting_is_today? || latest_minute.sent_invitation
        Rails.logger.info("notify_today_meeting wasn't executed #{{ 'course' => course.name }}")
        return
      end

      Discord::Notifier.message(NotificationMessageTemplate.create_message(:today_meeting, course, latest_minute), url: webhook_url(course))
      Rails.logger.info("notify_today_meeting executed #{{ 'course' => course.name, 'today_meeting_minute' => latest_minute.id }}")
      latest_minute.update!(sent_invitation: true)
    end

    def webhook_url(course)
      course.name == 'Railsエンジニアコース' ? ENV['RAILS_COURSE_WEBHOOK_URL'] : ENV['FRONTEND_COURSE_WEBHOOK_URL']
    end
  end
end
