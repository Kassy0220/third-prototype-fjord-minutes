class Minutes::AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ edit update destroy ]

  # GET /attendances/new
  def new
    @minute = Minute.find(params[:minute_id])
    @attendance = Attendance.new
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
    minute = Minute.find(params[:minute_id])
    @attendance = minute.attendances.new(attendance_params)
    @attendance.member_id = current_member.id

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to edit_minute_url(minute), notice: "Attendance was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to attendance_url(@attendance), notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy!

    respond_to do |format|
      format.html { redirect_to attendances_url, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def attendance_params
    params.require(:attendance).permit(:time, :absence_reason, :progress_report)
  end
end
