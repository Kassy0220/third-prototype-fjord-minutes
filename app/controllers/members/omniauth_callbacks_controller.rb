class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  skip_before_action :verify_authenticity_token, only: :github

  def github
    @member = Member.from_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

    if @member.persisted?
      sign_in_and_redirect @member
      remember_me @member
      set_flash_message(:notice, :success, kind: "GitHub") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_member_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
