namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Daniel Vogel",
                 email: "dvogel@cs.stanford.edu",
                 cellphone: "+16504556864",
                 password: "12341234",
                 password_confirmation: "12341234")
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 cellphone: "+11234567890",
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
                   password: password,
                   password_confirmation: password)
    end
  end
end