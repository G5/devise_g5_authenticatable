# frozen_string_literal: true

class DropRememberable < ActiveRecord::Migration[4.2]
  def up
    change_table(:users) do |t|
      t.remove :remember_created_at
    end
  end

  def down
    change_table(:users) do |t|
      t.datetime :remember_created_at
    end
  end
end
