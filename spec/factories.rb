FactoryGirl.define do
  factory :user do
    name     "Daniel Vogel"
    email    "vogel@example.com"
    cellphone "+11231234567"
    password "foobar"
    password_confirmation "foobar"
  end
end