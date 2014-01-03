class DropRememberable < ActiveRecord::Migration
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
