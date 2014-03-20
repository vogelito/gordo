FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:cellphone) { |n| "+1#{n.to_s.rjust(10, '0')}"}
    password "foobar"
    password_confirmation "foobar"
  end
end