class Api::Members::AttendancesController < ApplicationController
  def index
    member = Member.find(params[:member_id])
    member_attendances = member.attendance_records
    render json: member_attendances

  end
end