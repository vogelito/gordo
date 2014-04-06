class ChargesController < ApplicationController

  def new
  end

  def create
    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    current_user.update_attribute(:stripe_customer_id, customer.id)
    route_selector

  rescue Stripe::CardError => e
    flash[:error] = e.message
    current_user.update_attribute(:stripe_customer_id, "")
    redirect_to new_charge_path
  end

  def charge

  end
end
