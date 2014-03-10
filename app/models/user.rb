class User < ActiveRecord::Base
  has_many :orders

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # Alt  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  VALID_CELLPHONE_REGEX = /\A\+1\d{10}\Z/
  validates :cellphone, presence:true, uniqueness:true, format: { with: VALID_CELLPHONE_REGEX, message: "enter 10 digits" }
  validates :password, length: { minimum: 6 }

  before_validation do
    if attribute_present?("cellphone")
      # get rid of all non-numeric characters
      phone = cellphone.gsub(/[^0-9]/, "")
      phone = phone[1..-1] if phone.length == 11 && phone[0] == "1"
      self.cellphone = "+1" + phone
    end

    if attribute_present?("email")
      self.email = email.downcase
    end
  end

  has_secure_password
end
