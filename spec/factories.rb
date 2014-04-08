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
    food_item_id 1
    quantity 10
  end

  factory :food_item do
    title "Delicious Beef Pad Thai"
    description "some delicious pad thai made with extra love"
    picture_url "http://getgordo.com/pics/pad_thai.jpg"
    price 7.99
    active false
  end
end