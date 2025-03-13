class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email]&.downcase
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to user_path(user, locale: I18n.locale)
    else
      flash.now[:danger] = t "users.msg.invalid_msg"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    reset_session
    redirect_to root_path
  end
end
