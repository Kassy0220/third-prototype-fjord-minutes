module MinutesHelper
  def attendees_list(members)
    members.map{ |member_email| "- [#{member_name(member_email)}](#)" }.join("\n    ")
  end

  def absentees_list(members)
    members.map{ |member| "- [#{member_name(member[0])}](#)\n  - 進捗報告: #{member[1]}" }.join("\n")
  end

  def member_name(email)
    email.slice(/^[^@]+/)
  end

  def topics_list(topics)
    topics.map{ |topic| "- #{topic.content}" }.join("\n")
  end
end

