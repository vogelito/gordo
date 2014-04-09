module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.hash(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.hash(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    t = true
    route_selector if t
    return if t
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def get_active_order
    current_user.orders.each do |o|
      return o if o.pending
    end
    return nil
  end

  def redirect_or_return(target)
    target_path = Rails.application.routes.recognize_path(target)
    return if (params[:controller] == target_path[:controller] &&
                params[:action] == target_path[:action] &&
                params[:id] == target_path[:id])
    redirect_to target
  end

  def route_selector
    if !signed_in?
      redirect_or_return signing_url
    elsif current_user.admin?
      #TODO: checar bien que onda con admin
      #redirect_back_or(current_user)
      return
    elsif !current_user.stripe_customer_id?
      redirect_or_return new_charge_path
    end

    # We might have an order at this point
    order = get_active_order
    if order == nil
      redirect_or_return active_food_items_path
    elsif order.pending
      redirect_or_return user_path(@current_user)
    end
  end
end