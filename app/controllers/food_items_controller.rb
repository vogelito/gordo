class FoodItemsController < ApplicationController
  before_action :signed_in_user, only: [:index]
  before_action :admin_user, only: :index

  def index
    @food_items = FoodItem.paginate(page: params[:page])
  end

  def new
  end
end
