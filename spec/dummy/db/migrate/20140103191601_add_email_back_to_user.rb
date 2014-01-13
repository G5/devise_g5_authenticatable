class AddEmailBackToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string,
                               null: false,
                               default: ''
    add_index :users, :email, unique: true
  end
end
