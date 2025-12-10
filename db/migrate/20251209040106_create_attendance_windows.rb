class CreateAttendanceWindows < ActiveRecord::Migration[8.1]
  def change
    create_table :attendance_windows do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
