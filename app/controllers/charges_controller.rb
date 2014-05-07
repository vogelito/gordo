class ChargesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def new
  end

  def create
    customer = Stripe::Customer.create(
      :email => current_user.email,
      :description => "Payments for: #{current_user.name}",
      :card  => params[:stripeToken]
    )
    current_user.update_attribute(:stripe_customer_id, customer.id)
    route_selector

  rescue Stripe::CardError => e
    process_error e
  end

  def charge
    order = get_pending_order
    food_item = FoodItem.find(order.food_item_id)
    Stripe::Charge.create(
      :amount => (order.quantity * food_item.price * 100).round,
      :currency => "usd",
      :customer => current_user.stripe_customer_id
    )

    # At this point the order has been paid for
    order.update_attribute(:paid, true)
    route_selector
  rescue Stripe::CardError => e
    process_error e
  end

  private
    def process_error e
      flash[:error] = e.message
      current_user.update_attribute(:stripe_customer_id, "")
      redirect_to new_charge_path
    end
end
