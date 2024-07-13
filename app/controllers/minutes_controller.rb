class MinutesController < ApplicationController
  skip_before_action :authenticate_member!, only: [:index]
  before_action :set_minute, only: %i[ show edit update destroy ]

  # GET /minutes or /minutes.json
  def index
    @course = Course.find(params[:course_id])
    @minutes = @course.minutes.order(:created_at)
  end

  # GET /minutes/1 or /minutes/1.json
  def show
    @day_attendees = @minute.attendances.where(time: :day).includes(:member).pluck(:email)
    @night_attendees = @minute.attendances.where(time: :night).includes(:member).pluck(:email)
    @absent_members = @minute.attendances.where(time: :absence).includes(:member).pluck(:email, :progress_report)
  end

  # GET /minutes/new
  def new
    @course = Course.find(params[:course_id])
    @minute = Minute.new
  end

  # GET /minutes/1/edit
  def edit
  end

  # POST /minutes or /minutes.json
  def create
    course = Course.find(params[:course_id])
    @minute = course.minutes.new(minute_params)

    respond_to do |format|
      if @minute.save
        format.html { redirect_to minute_url(@minute), notice: "Minute was successfully created." }
        format.json { render :show, status: :created, location: @minute }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @minute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /minutes/1 or /minutes/1.json
  def update
    respond_to do |format|
      if @minute.update(minute_params)
        format.html { redirect_to minute_url(@minute), notice: "Minute was successfully updated." }
        format.json { render :show, status: :ok, location: @minute }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @minute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /minutes/1 or /minutes/1.json
  def destroy
    course = @minute.course
    @minute.destroy!

    respond_to do |format|
      format.html { redirect_to course_minutes_url(course), notice: "Minute was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_minute
      @minute = Minute.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def minute_params
      params.require(:minute).permit(:title, :release_branch, :release_note, :other, :date, :next_date)
    end
end
