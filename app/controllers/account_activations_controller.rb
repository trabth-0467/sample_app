class AccountActivationsController < ApplicationController
  include ApplicationHelper
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation,
                                                       params[:id])
      user.activate
      log_in user
      flash[:success] = t "account_activations.mailer.account_activated"
    else
      flash[:danger] = t "account_activations.mailer.invalid_activation_link"
    end
    redirect_to root_path
  end
end
