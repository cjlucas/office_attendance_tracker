class AttendanceWindowSerializer < Blueprinter::Base
  identifier :id

  fields :start_date, :end_date, :created_at, :updated_at, :days_remaining

  field :attendance_count do |window|
    window.attendances.count
  end
end
