FactoryGirl.define do
  factory :user do
    name     "Daniel Vogel"
    email    "dvogel@cs.stanford.edu"
    cellphone "+11231234567"
    password "foobar"
    password_confirmation "foobar"
  end
end