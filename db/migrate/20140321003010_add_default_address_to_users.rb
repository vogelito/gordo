class AddDefaultAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_address, :string
  end
end
