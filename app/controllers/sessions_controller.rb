class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user
    if user.try :authenticate, params.dig(:session, :password)
      reset_session
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      redirect_to user_path(user, locale: I18n.locale), status: :see_other
    else
      flash.now[:danger] = t "msg.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    reset_session
    redirect_to root_path
  end

  private
  def find_user
    User.find_by email: params.dig(:session, :email)&.downcase
  end
end
