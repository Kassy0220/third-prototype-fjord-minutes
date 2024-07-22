class NotificationMessageTemplate
  include Rails.application.routes.url_helpers
  include DateHelper
  ROLE_ID = ENV['TEAM_MEMBER_ROLE_ID'].to_i
  MESSAGE_TEMPLATE_FOR_MINUTE_CREATION = 'config/message_template/minute_creation.md'
  MESSAGE_TEMPLATE_FOR_TODAY_MEETING = 'config/message_template/today_meeting.md'

  def self.create_message(message_type, course, minute)
    new(message_type).create_message(course, minute)
  end

  def initialize(message_type)
    @template = case message_type
                when :create
                  File.read(MESSAGE_TEMPLATE_FOR_MINUTE_CREATION)
                when :today_meeting
                  File.read(MESSAGE_TEMPLATE_FOR_TODAY_MEETING)
                else
                  raise ArgumentError, "Invalid message_type: #{message_type.inspect}"
                end
  end

  def create_message(course, minute)
    ERB.new(@template).result_with_hash({ role_id: ROLE_ID, course_name: course.name, meeting_date: format_date(minute.date), url: new_minute_attendance_url(minute) })
  end
end
