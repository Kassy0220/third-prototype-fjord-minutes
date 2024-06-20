class Api::MinutesController < ApplicationController
  def show
    minute = Minute.find(params[:id])
    render json: minute
  end

  def update
    minute = Minute.find(params[:id])
    if minute.update(minute_params)
      render json: minute, status: :ok
    else
      render json: minute.errors, status: :unprocessable_entity
    end
  end

  private
  def minute_params
    params.require(:minute).permit(:release_branch, :release_note, :other)
  end

end