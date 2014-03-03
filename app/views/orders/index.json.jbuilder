json.array!(@orders) do |order|
  json.extract! order, :address, :lat, :lng, :user_id
  json.url order_url(order, format: :json)
end