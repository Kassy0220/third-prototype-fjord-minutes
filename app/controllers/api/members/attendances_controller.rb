class Api::Members::AttendancesController < ApplicationController
  def index
    member = Member.find(params[:member_id])
    member_attendances = Attendance.joins('INNER JOIN minutes ON minutes.id = attendances.minute_id')
                                   .where(attendances: { member_id: member.id })
                                   .pluck(:id, :date, :time, :absence_reason)
    render json: member_attendances

  end
end