# frozen_string_literal: true

class DropDatabaseAuthenticatable < ActiveRecord::Migration[4.2]
  def up
    change_table(:users) do |t|
      t.remove :email
      t.remove :encrypted_password
    end
  end

  def down
    change_table(:users) do |t|
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.index :email, unique: true
    end
  end
end
