class CreateExclusionPeriods < ActiveRecord::Migration[8.1]
  def change
    create_table :exclusion_periods do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :exclusion_periods, :start_date
    add_index :exclusion_periods, :end_date
  end
end
