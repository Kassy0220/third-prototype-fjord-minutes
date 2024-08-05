class Minutes::ExportsController < MinutesController
  def create
    minute = Minute.find(params[:minute_id])
    day_attendees = minute.attendances.where(time: :day).includes(:member).pluck(:email)
    night_attendees = minute.attendances.where(time: :night).includes(:member).pluck(:email)
    absent_members = minute.attendances.where(time: :absence).includes(:member).pluck(:email, :progress_report)

    GithubWikiManager.export_minute(minute, day_attendees, night_attendees, absent_members)

    redirect_to course_minutes_path(minute.course), notice: "GitHub Wikiに議事録を反映させました"
  end
end
