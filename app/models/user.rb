class User < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true
  validates :email, presence:true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  validates :cellphone, presence:true, uniqueness:true, format: { with: /\A\+1\d{10}\z/, message: "enter 10 digits" }

  before_validation(on: :create) do
    if attribute_present?("cellphone")
      # get rid of all non-numeric characters
      phone = cellphone.gsub(/[^0-9]/, "")
      phone = phone[1..-1] if phone.length == 11 && phone[0] == "1"
      self.cellphone = "+1" + phone
    end
  end
end
