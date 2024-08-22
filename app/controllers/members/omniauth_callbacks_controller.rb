class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  skip_before_action :verify_authenticity_token, only: [:github, :developer]
  skip_before_action :prohibit_hiatus_member_access, only: :github

  def github
    authenticate_with_omniauth('GitHub')
  end

  def developer
    authenticate_with_omniauth('Developer')
  end

  def failure
    redirect_to root_path
  end

  private

  def authenticate_with_omniauth(provider)
    @member = Member.from_omniauth(request.env["omniauth.auth"], request.env["omniauth.params"])

    if @member.persisted?
      @member.hiatuses.last.update(finished_at: Time.zone.now) if @member.hiatus?
      sign_in_and_redirect @member
      remember_me @member
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_member_registration_url
    end
  end
end
