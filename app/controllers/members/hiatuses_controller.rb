class Members::HiatusesController < ApplicationController
  def create
    member = Member.find(params[:member_id])

    if member.hiatuses.create!
      redirect_to members_path, notice: "#{member.name} is now hiatus."
    else
      render members_path, status: :unprocessable_entity
    end
  end
end
