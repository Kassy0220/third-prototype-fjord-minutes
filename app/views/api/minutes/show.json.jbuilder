attendances = @minute.attendances.includes(:member)

day_participants = attendances.where(time: :day).map do |attendance|
  {
    attendance_id: attendance.id,
    member_name: attendance.member.login_name,
  }
end

json.day day_participants

night_participants = attendances.where(time: :night).map do |attendance|
  {
    attendance_id: attendance.id,
    member_name: attendance.member.login_name,
  }
end

json.night night_participants

absences = attendances.where(time: :absence).map do |attendance|
  {
    attendance_id: attendance.id,
    member_name: attendance.member.login_name,
    absence_reason: attendance.absence_reason,
    progress_report: attendance.progress_report
  }
end

json.absence absences
