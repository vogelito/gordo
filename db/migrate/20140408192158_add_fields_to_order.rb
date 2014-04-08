class AddFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :food_item_id, :integer
    add_column :orders, :quantity, :integer
    add_column :orders, :delivered, :boolean, default: false
    add_column :orders, :paid, :boolean, default: false
  end
end
