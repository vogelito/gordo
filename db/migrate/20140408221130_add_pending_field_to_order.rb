class AddPendingFieldToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :pending, :boolean, default: true
  end
end
