class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy current_user.feed,
                              limit: Settings.micropost.pagy_items
  end

  def help; end
end
