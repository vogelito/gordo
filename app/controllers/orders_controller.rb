class OrdersController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy, :show]

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:success] = "Order created!"
      redirect_to order_path(@order)
    else
      # Try to redirect him back to the Add Order page if we have a food_item_id
      if @order.food_item_id != nil
        @food_item = FoodItem.find(@order.food_item_id)
        render :template => "food_items/show"
      else
        redirect_to user_path(@current_user)
      end
    end
  end

  def destroy
    if @order.paid || @order.delivered
      flash[:error] = "You cannot delete an order you've paid for!"
    else
      @order.destroy
    end
    route_selector
  end

  private

    def order_params
      params.require(:order).permit(:address, :quantity, :food_item_id)
    end

    def correct_user
      @order = current_user.orders.find_by(id: params[:id])
      redirect_to root_url if @order.nil?
    end
end