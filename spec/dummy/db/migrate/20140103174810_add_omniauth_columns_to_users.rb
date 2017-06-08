# frozen_string_literal: true

class AddOmniauthColumnsToUsers < ActiveRecord::Migration[4.2]
  def up
    change_table(:users) do |t|
      t.string :uid
      t.string :provider
      t.string :g5_access_token
      t.index [:provider, :uid], unique: true
    end
  end

  def down
    change_table(:users) do |t|
      t.remove :uid
      t.remove :provider
      t.remove :g5_access_token
    end
  end
end
