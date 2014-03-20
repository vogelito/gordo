class OrdersController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      flash[:success] = "Order created!"
      redirect_to root_url
    else
      # TODO: remove...
      @feed_items = []
      render 'static_pages/home'
    end
  end

  #TODO: this shouldn't be allowed
  def destroy
    @order.destroy
    redirect_to root_url
  end

  private

    def order_params
      params.require(:order).permit(:address)
    end

    def correct_user
      @order = current_user.orders.find_by(id: params[:id])
      redirect_to root_url if @order.nil?
    end
end