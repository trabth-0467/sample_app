class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  def index
    @pagy, @users = pagy(User.all, items: Settings.user.pagy_items)
  end

  def show
    if @user
      @page, @microposts = pagy @user.microposts.newest,
                                limit: Settings.micropost.pagy_items
    else
      flash[:danger] = t "users.msg.not_found"
      redirect_to root_path
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = t "users.show.update_success"
      redirect_to user_path(@user, locale: I18n.locale)
    else
      flash.now[:danger] = t "users.show.update_fail"
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:warning] = t "account_activations.mailer.account_check_email"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t "users.show.destroy_success"
    else
      flash[:danger] = t "users.show.destroy_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRIBUTES)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "users.msg.not_found"
    redirect_to root_path
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t "not_user"
    redirect_to root_path
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
