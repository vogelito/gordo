FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    sequence(:cellphone) { |n| "+1#{n.to_s.rjust(10, '0')}"}
    default_address "1 Western Ave Unit 1305"
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :order do
    address "1 Western Ave"
    user
  end
end