class AddResetPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_code, :string
  end
end
