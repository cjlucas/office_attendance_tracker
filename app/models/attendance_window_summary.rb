class AttendanceWindowSummary
  REQUIRED_MINIMUM_ATTENDANCE = 20

  attr_reader :attendance_window

  def initialize(attendance_window)
    @attendance_window = attendance_window
  end

  def days_attended
    @days_attended ||=
      @attendance_window
      .attendances
      .map(&:to_date)
      .intersection(workdays)
  end

  def required_attendances_remaining
    (REQUIRED_MINIMUM_ATTENDANCE - days_attended.count).clamp(0..)
  end

  def days_remaining
    start = [Date.current, @attendance_window.start_date].max
    (start..@attendance_window.end_date).to_a.intersection(workdays)
  end

  private

  # Designates the actual valid workdays within a window, this
  # excludes any days that fall in an exclusion period or the weekend.
  def workdays
    @workdays ||= begin
      days = @attendance_window.to_range.to_a

      @attendance_window.exclusion_periods.each do |period|
        days -= period.to_range.to_a
      end

      days.find_all { |day| !(day.saturday? || day.sunday?) }
    end
  end
end
