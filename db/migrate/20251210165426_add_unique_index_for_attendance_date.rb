class AddUniqueIndexForAttendanceDate < ActiveRecord::Migration[8.1]
  def up
    add_index :attendances, :date, unique: true
  end

  def down
    remove_index :attendances, :date, unique: true
  end
end
