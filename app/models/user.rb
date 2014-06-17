class User < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # Alt  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  VALID_CELLPHONE_REGEX = /\A\+1\d{10}\Z/
  validates :cellphone, presence:true, uniqueness:true, format: { with: VALID_CELLPHONE_REGEX, message: "format should be (123) 555-1234" }
  validates :default_address, presence: true, length: { maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }#, if: lambda { |m| m.password.present? }


  before_create :create_remember_token

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
  scope :find_by_reset_token, -> (token) {where("reset_password_code = ?", token).last}
  #TODO: remove...
  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Order.where("user_id = ?", id)
  end

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def reset_new_password(password, confirmed_password)
    update_attributes({password: password, password_confirmation: confirmed_password, reset_password_code: ''})
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
