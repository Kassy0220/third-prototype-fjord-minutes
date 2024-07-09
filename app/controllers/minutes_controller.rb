class MinutesController < ApplicationController
  skip_before_action :authenticate_member!, only: [:index]
  before_action :set_minute, only: %i[ show edit update destroy ]

  # GET /minutes or /minutes.json
  def index
    @minutes = Minute.all.order(:created_at)
  end

  # GET /minutes/1 or /minutes/1.json
  def show
    @day_attendees = @minute.attendances.where(time: :day).includes(:member).pluck(:email)
                            .map{ |email| "- [#{email.slice(/^[^@]+/)}](#)" }.join("\n    ")
    @night_attendees = @minute.attendances.where(time: :night).includes(:member).pluck(:email)
                               .map{ |email| "- [#{email.slice(/^[^@]+/)}](#)" }.join("\n    ")
    @topics = @minute.topics.map{ |topic| "- #{topic.content}" }.join("\n")
    # TODO: 欠席者の欠席理由は表示しない
    @absent_members = @minute.attendances.where(time: :absence).includes(:member).pluck(:email, :absence_reason, :progress_report)
                                .map{ |absence| "- [#{absence[0].slice(/^[^@]+/)}](#)\n  - 欠席理由: #{absence[1]}\n  - 進捗報告: #{absence[2]}" }.join("\n")
  end

  # GET /minutes/new
  def new
    @minute = Minute.new
  end

  # GET /minutes/1/edit
  def edit
  end

  # POST /minutes or /minutes.json
  def create
    @minute = Minute.new(minute_params)

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
    @minute.destroy!

    respond_to do |format|
      format.html { redirect_to minutes_url, notice: "Minute was successfully destroyed." }
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
      params.require(:minute).permit(:title, :release_branch, :release_note, :other, :next_date)
    end
end
