class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :address
      t.float :lat
      t.float :lng
      t.integer :user_id

      t.timestamps
    end
  end
end
