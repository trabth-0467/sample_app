class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  private

  def set_locale
    locale = params[:locale]&.strip&.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "need_login"
    redirect_to login_path
  end
end
