class MinuteTemplate
  DEFAULT_PATH = 'config/minute_template/minute.md'

  def self.build(minute, day_attendees, night_attendees, topics, absent_members)
    template = File.read(DEFAULT_PATH)
    ERB.new(template).result_with_hash({ minute:, day_attendees:, night_attendees:, topics:, absent_members: })
  end
end
