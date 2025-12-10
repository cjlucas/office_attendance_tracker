class Attendance < ApplicationRecord
  validates :date, uniqueness: true

  def self.in_window(window)
    Attendance.where(Attendance.arel_table[:date].between(window.start_date..window.end_date))
  end
end
