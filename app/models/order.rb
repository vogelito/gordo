class Order < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('paid DESC, delivered ASC, created_at DESC') }
  validates :address, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
  validates :food_item_id, presence: true
  validates :quantity, presence: true,
            :numericality => {:greater_than_or_equal_to => 1,
                              :less_than_or_equal_to => Gordo::Application::MAX_QUANTITY}
end
