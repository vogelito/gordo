class AddTitleToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :title, :string
  end
end
