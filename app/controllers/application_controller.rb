class ApplicationController < ActionController::Base
  before_action :authenticate_member!
  before_action :prohibit_hiatus_member_access

  private
  def prohibit_hiatus_member_access
    if member_signed_in? && current_member.hiatus?
      sign_out
      redirect_to new_member_session_path, alert: '休会中のメンバーは再度ログインをお願いします'
    end
  end
end
