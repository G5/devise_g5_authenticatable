# frozen_string_literal: true

class AddEmailBackToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email, :string,
                               null: false,
                               default: ''
    add_index :users, :email, unique: true
  end
end
