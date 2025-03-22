class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to user_path(@user, locale: I18n.locale)}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to user_path(@user, locale: I18n.locale)}
      format.js
    end
  end
  private

  def load_user
    @user = User.find(params[:followed_id])
  end

  def load_relationship
    @relationship = Relationship.find(params[:id])
  end
end
