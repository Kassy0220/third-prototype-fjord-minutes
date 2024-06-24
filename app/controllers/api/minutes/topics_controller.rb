class Api::Minutes::TopicsController < ApplicationController
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
      MinuteChannel.broadcast_to(minute, { body: { topics: minute.topics } })
    else
      render json: @topic.errors, status: :unprocessable_entity
    end
  end

  private
  def topic_params
    params.require(:topic).permit(:content)
  end
end