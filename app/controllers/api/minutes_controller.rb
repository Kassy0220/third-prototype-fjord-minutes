class Api::MinutesController < ApplicationController
  def show
    @minute = Minute.find(params[:id])
  end

  def update
    minute = Minute.find(params[:id])
    if minute.update(minute_params)
      render json: minute, status: :ok
      MinuteChannel.broadcast_to(minute, { body: { minute: minute.as_json(only: [:release_branch, :release_note, :other, :next_date]) } })
    else
      render json: minute.errors, status: :unprocessable_entity
    end
  end

  private
  def minute_params
    params.require(:minute).permit(:release_branch, :release_note, :other, :next_date)
  end

end
