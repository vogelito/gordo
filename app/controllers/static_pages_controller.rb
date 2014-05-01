class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @order  = current_user.orders.build
      #TODO: remove....
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def how_its_work
  end
end
