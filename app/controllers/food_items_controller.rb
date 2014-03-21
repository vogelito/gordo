class FoodItemsController < ApplicationController
  before_action :signed_in_user, only: [:index]
  before_action :admin_user, only: [:index, :destroy]

  def index
    @food_items = FoodItem.paginate(page: params[:page])
  end

  def new
  end

  def destroy
    FoodItem.find(params[:id]).destroy
    flash[:success] = "Food Item deleted."
    redirect_to food_items_url
  end
end
