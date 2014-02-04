class AddProviderAndUidToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :provider, :string
    add_column :admins, :uid, :string
    add_column :admins, :g5_access_token, :string
    add_index :admins, [:provider, :uid], unique: true
  end
end
