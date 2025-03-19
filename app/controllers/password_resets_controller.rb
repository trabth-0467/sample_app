class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_password1"
      redirect_to root_path
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("noti.password_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "noti.password_success"
      redirect_to user_path(@user, locale: I18n.locale)
    else
      render :edit
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "users.msg.not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t "users.msg.invalid_msg"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "noti.password_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
