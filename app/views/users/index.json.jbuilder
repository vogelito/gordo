json.array!(@users) do |user|
  json.extract! user, :name, :email, :cellphone
  json.url user_url(user, format: :json)
end