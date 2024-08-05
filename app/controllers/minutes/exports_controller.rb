class Minutes::ExportsController < MinutesController
  def create
    minute = Minute.find(params[:minute_id])
    GithubWikiManager.export_minute(minute)

    redirect_to course_minutes_path(minute.course), notice: "GitHub Wikiに議事録を反映させました"
  end
end
