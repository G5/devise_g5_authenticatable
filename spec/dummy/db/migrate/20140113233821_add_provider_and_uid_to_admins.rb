# frozen_string_literal: true

class AddProviderAndUidToAdmins < ActiveRecord::Migration[4.2]
  def change
    add_column :admins, :provider, :string
    add_column :admins, :uid, :string
    add_column :admins, :g5_access_token, :string
    add_index :admins, [:provider, :uid], unique: true
  end
end
