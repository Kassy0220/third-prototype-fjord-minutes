class Api::Minutes::TopicsController < ApplicationController
  # 検証用のメソッドなので削除すること
  def index
    minute = Minute.find(params[:minute_id])
    topics = minute.topics
    render json: topics
  end

  def create
    minute = Minute.find(params[:minute_id])
    @topic = minute.topics.create(topic_params)
    if @topic
      render json: @topic, status: :created
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  private
  def topic_params
    params.require(:topic).permit(:content)
  end
end