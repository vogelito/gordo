class RemovePendingFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :pending, :boolean
  end
end
