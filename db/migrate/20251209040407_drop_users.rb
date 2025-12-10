class DropUsers < ActiveRecord::Migration[8.1]
  def change
    drop_table :users
  end
end
