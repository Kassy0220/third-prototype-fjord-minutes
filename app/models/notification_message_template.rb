class NotificationMessageTemplate
  ROLE_ID = ENV['TEAM_MEMBER_ROLE_ID'].to_i
  def self.create_message(message_type, course, minute)
    template = case message_type
               when :create
                 File.read('config/message_template/minute_creation.md')
               else
                 File.read('config/message_template/minute_creation.md')
               end
    ERB.new(template).result_with_hash({ role_id: ROLE_ID, course_name: course.name, meeting_date: minute.date, url: "https://fjord_minutes/minutes/#{minute.id}/attendances/new" })
  end
end
