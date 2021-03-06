class SessionsController < ApplicationController
  include CurrentAccount

  skip_before_action :verify_authenticity_token

  layout 'auth'

  def new
    render locals: { session_form: SessionForm.new(remember_me: true) }
  end

  def create
    session_form = SessionForm.new permitted_params
    user = login session_form.login, session_form.password, session_form.remember_me

    if user
      self.current_account = current_user.default_account
      redirect_to account_root_url
    else
      redirect_to :back, flash: { error: t('flashes.user.session_failed') }
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

  private

  def permitted_params
    params.require(:session_form).permit(:login, :password, :remember_me)
  end
end
