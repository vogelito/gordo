class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, [:email, :cellphone], unique: true
  end
end
