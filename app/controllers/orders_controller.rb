class OrdersController < ApplicationController
  before_action :signed_in_user

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:success] = "Order created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def order_params
      params.require(:order).permit(:address)
    end
end