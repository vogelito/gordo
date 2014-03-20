class AddIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, [:user_id, :created_at]
  end
end
