module OrdersHelper

  def delivery_link_text(order)
    order.delivered? ? 'Mark as Not Delivered' : 'Mark as Delivered'
  end

  def is_delivered_text(order)
    order.delivered? ? 'Delivered' : 'Delivery Pending'
  end

  def is_paid_text(order)
    order.paid? ? 'Paid' : 'Payment Pending'
  end

  def wrap(address)
    sanitize(raw(address.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end
