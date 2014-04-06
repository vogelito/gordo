class FoodItem < ActiveRecord::Base
  default_scope -> { order('active DESC, created_at DESC') }
  validates :title, presence: true, length: { maximum: 40 }
  validates :description, presence: true, length: { maximum: 140 }
  validates :picture_url, presence: true
  validates :price, presence: true, format: { with: /\A\d+??(?:\.\d{0,2})?\Z/ },
            :numericality => {:greater_than_or_equal_to => Gordo::Application::MIN_PRICE,
                              :less_than_or_equal_to => Gordo::Application::MAX_PRICE}
end