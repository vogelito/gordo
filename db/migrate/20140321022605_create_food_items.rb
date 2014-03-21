class CreateFoodItems < ActiveRecord::Migration
  def change
    create_table :food_items do |t|
      t.string :description
      t.string :picture_url
      t.decimal :price, precision: 10, scale: 2
      t.boolean :active

      t.timestamps
    end
  end
end
