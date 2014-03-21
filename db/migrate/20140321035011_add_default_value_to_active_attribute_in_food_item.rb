class AddDefaultValueToActiveAttributeInFoodItem < ActiveRecord::Migration
  def change
    change_column_default :food_items, :active, false
  end
end
