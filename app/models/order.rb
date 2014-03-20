class Order < ActiveRecord::Base
  validates :user_id, presence: true
  belongs_to :user

  validates :address, presence: true
end
