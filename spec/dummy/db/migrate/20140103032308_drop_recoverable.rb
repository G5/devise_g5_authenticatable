# frozen_string_literal: true

class DropRecoverable < ActiveRecord::Migration[4.2]
  def up
    change_table(:users) do |t|
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
    end
  end

  def down
    change_table(:users) do |t|
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.index :reset_password_token, unique: true
    end
  end
end
