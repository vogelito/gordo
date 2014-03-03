class Order < ActiveRecord::Base
  belongs_to :user

  validates :address, presence: true
end
