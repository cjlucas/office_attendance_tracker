class DropUserIdFromAttendances < ActiveRecord::Migration[8.1]
  def change
    remove_column :attendances, :user_id, :references
  end
end
