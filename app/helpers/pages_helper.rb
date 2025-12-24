module PagesHelper
  REQUIRED_MINIMUM_ATTENDANCE = 20
  WEEKEND_DAYS = [ "Saturday", "Sunday" ]

  def recent_attendance(limit: 5)
    Attendance.order(date: :desc).limit(limit)
  end

  def active_attendance_windows
    AttendanceWindow.active.order(start_date: :asc)
  end

  def required_attendances_remaining(window)
    (REQUIRED_MINIMUM_ATTENDANCE - valid_days_attended(window).count).clamp(0..)
  end

  def valid_days_attended(window)
    attendances = window.attendances.find_all do |attendance|
      !WEEKEND_DAYS.include?(Date::DAYNAMES[attendance.date.wday])
    end
  end

  def applicable_days_remaining(window)
    (Date.current..window.end_date)
      .find_all { |day| !WEEKEND_DAYS.include?(day) }
      .count
  end

  def upcoming_exclusion_periods
    day = Date.current

    ExclusionPeriod
      .where("start_date >= ? OR end_date >= ?", day, day)
      .order(start_date: :asc)
  end
end
