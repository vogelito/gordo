def get_address
  "#{Faker::Address.street_address}, #{Faker::Address.secondary_address}, #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}"
end

def get_random_number(min, max, precision)
   ((max - min) * rand() + min).round(precision)
end

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Daniel Vogel",
                 email: "dvogel@cs.stanford.edu",
                 cellphone: "+16504556864",
                 default_address: "1 Western Ave Unir 1305, Boston, MA 02163",
                 password: "12341234",
                 password_confirmation: "12341234",
                 admin: true)
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 cellphone: "+11234567890",
                 default_address: get_address,
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      cellphone = "+1#{n.to_s.rjust(10, '0')}"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   cellphone: cellphone,
                   default_address: get_address,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
    50.times do
      address = get_address
      users.each { |user| user.orders.create!(address: address) }
    end

    50.times do
      FoodItem.create!(title: Faker::Lorem.sentence(1)[0..39],
                    description: Faker::Lorem.sentence(6),
                    picture_url: "http://getgordo.com/pics/pad_thai.jpg",
                    price: get_random_number(Gordo::Application::MIN_PRICE,Gordo::Application::MAX_PRICE,2))
    end

  end
end