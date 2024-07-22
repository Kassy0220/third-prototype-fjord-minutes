class NotificationMessageTemplate
  include DateHelper
  ROLE_ID = ENV['TEAM_MEMBER_ROLE_ID'].to_i
  MESSAGE_TEMPLATE_FOR_MINUTE_CREATION = 'config/message_template/minute_creation.md'

  def self.create_message(message_type, course, minute)
    new(message_type).create_message(course, minute)
  end

  def initialize(message_type)
    @template = case message_type
                when :create
                  File.read(MESSAGE_TEMPLATE_FOR_MINUTE_CREATION)
                else
                  File.read(MESSAGE_TEMPLATE_FOR_MINUTE_CREATION)
                end
  end

  def create_message(course, minute)
    ERB.new(@template).result_with_hash({ role_id: ROLE_ID, course_name: course.name, meeting_date: format_date(minute.date), url: "https://fjord_minutes/minutes/#{minute.id}/attendances/new" })
  end
end
