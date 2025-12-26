module PagesHelper
  def recent_attendance(limit: 5)
    Attendance.order(date: :desc).limit(limit)
  end

  def active_attendance_windows
    AttendanceWindow.active.order(start_date: :asc)
  end

  def upcoming_exclusion_periods
    day = Date.current

    ExclusionPeriod
      .where("start_date >= ? OR end_date >= ?", day, day)
      .order(start_date: :asc)
  end
end
