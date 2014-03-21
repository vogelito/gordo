class FoodItem < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :picture_url, presence: true
  validates :price, presence: true
end
