class Add2026Data < ActiveRecord::Migration[8.1]
  ATTENDANCE_WINDOWS = [
    { start_date: "2025-12-15", end_date: "2026-03-13" },
    { start_date: "2026-01-19", end_date: "2026-04-17" },
    { start_date: "2026-02-16", end_date: "2026-05-15" },
    { start_date: "2026-03-16", end_date: "2026-06-12" },
    { start_date: "2026-04-20", end_date: "2026-07-17" },
    { start_date: "2026-05-18", end_date: "2026-08-14" },
    { start_date: "2026-06-22", end_date: "2026-09-18" },
    { start_date: "2026-07-20", end_date: "2026-10-16" },
    { start_date: "2026-08-17", end_date: "2026-11-13" },
    { start_date: "2026-09-21", end_date: "2026-12-18" }
  ]

  EXCLUSION_PERIODS = [
    # Winter Holidays
    { start_date: "2025-12-22", end_date: "2026-01-02" },
    # MLK Day
    { start_date: "2026-01-19", end_date: "2026-01-19" },
    # President's Day
    { start_date: "2026-02-16", end_date: "2026-02-16" },
    # Memorial Day
    { start_date: "2026-05-25", end_date: "2026-05-25" },
    # Juneteenth
    { start_date: "2026-06-19", end_date: "2026-06-19" },
    # 4th of July
    { start_date: "2026-06-29", end_date: "2026-07-03" },
    # Labor Day
    { start_date: "2026-09-07", end_date: "2026-09-07" },
    # Indigenous People's Day
    { start_date: "2026-10-12", end_date: "2026-10-12" },
    # Veteran's Day
    { start_date: "2026-11-11", end_date: "2026-11-11" },
    # Thanksgiving
    { start_date: "2026-11-23", end_date: "2026-11-27" }
  ]

  def up
    ATTENDANCE_WINDOWS.each do |window|
      puts "Creating attendance window: #{window[:start_date]} - #{window[:end_date]}"
      AttendanceWindow.create!(**window)
    end

    EXCLUSION_PERIODS.each do |period|
      puts "Creating exclusion period: #{period[:start_date]} - #{period[:end_date]}"
      ExclusionPeriod.create!(**period)
    end
  end

  def down
    ATTENDANCE_WINDOWS.each do |window|
      puts "Destroying attendance window: #{window[:start_date]} - #{window[:end_date]}"
      AttendanceWindow.where(**window).destroy_all
    end

    EXCLUSION_PERIODS.each do |period|
      puts "Destroying exclusion period: #{period[:start_date]} - #{period[:end_date]}"
      ExclusionPeriod.where(**period).destroy_all
    end
  end
end
