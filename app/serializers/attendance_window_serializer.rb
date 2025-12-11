class AttendanceWindowSerializer < Blueprinter::Base
  identifier :id

  fields :start_date, :end_date, :created_at, :updated_at

  field :days_remaining do |window|
    (window.end_date - Date.today).to_i + 1
  end

  field :attendance_count do |window|
    window.attendances.count
  end
end
