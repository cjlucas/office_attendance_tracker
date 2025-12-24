# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Helper to generate attendance for a date range
# Primary pattern: Tue, Wed, Thu
# Occasional: Monday on even weeks
def seed_attendance_for_range(start_date, end_date)
  current_date = start_date

  while current_date <= end_date
    case current_date.wday
    when 2, 3, 4 # Tuesday, Wednesday, Thursday (primary days)
      Attendance.find_or_create_by!(date: current_date)
    when 1 # Monday (occasional - every other week)
      Attendance.find_or_create_by!(date: current_date) if current_date.cweek.even?
    end

    current_date += 1.day
  end
end

# Helper to create exclusion periods
def seed_exclusion_period(start_date, end_date)
  ExclusionPeriod.find_or_create_by!(start_date: start_date) do |period|
    period.end_date = end_date
  end
end

puts "Seeding attendance windows..."

# Generate rolling 3-month windows for 2025-2027
# A new window starts each month
(Date.new(2025, 1, 1)..Date.new(2027, 12, 1)).select { |d| d.day == 1 }.each do |start_date|
  end_date = start_date + 3.months - 1.day

  AttendanceWindow.find_or_create_by!(start_date: start_date) do |window|
    window.end_date = end_date
  end
end

puts "Seeding exclusion periods..."

# Winter holidays (year-end shutdown)
seed_exclusion_period(Date.new(2024, 12, 24), Date.new(2024, 12, 31))
seed_exclusion_period(Date.new(2025, 12, 24), Date.new(2025, 12, 31))
seed_exclusion_period(Date.new(2026, 12, 24), Date.new(2026, 12, 31))

# Company-wide events (hypothetical all-hands in Q1 each year)
seed_exclusion_period(Date.new(2025, 1, 20), Date.new(2025, 1, 22))
seed_exclusion_period(Date.new(2026, 1, 19), Date.new(2026, 1, 21))
seed_exclusion_period(Date.new(2027, 1, 18), Date.new(2027, 1, 20))

# Summer shutdowns
seed_exclusion_period(Date.new(2025, 7, 1), Date.new(2025, 7, 7))
seed_exclusion_period(Date.new(2026, 7, 1), Date.new(2026, 7, 7))
seed_exclusion_period(Date.new(2027, 7, 1), Date.new(2027, 7, 7))

puts "Seeding attendance records..."

# Historical attendance (Oct 2024 - Nov 2024)
seed_attendance_for_range(Date.new(2024, 10, 1), Date.new(2024, 11, 30))

# Recent attendance (Dec 2024 - skip exclusion period for winter holidays)
seed_attendance_for_range(Date.new(2024, 12, 1), Date.new(2024, 12, 23))

# Current attendance (Jan 2025)
seed_attendance_for_range(Date.new(2025, 1, 1), Date.new(2025, 1, 19))
# Skip Jan 20-22 (company event exclusion)
seed_attendance_for_range(Date.new(2025, 1, 23), Date.new(2025, 1, 31))

# Weekend attendances (rare, but as examples)
Attendance.find_or_create_by!(date: Date.new(2024, 11, 9))  # Saturday
Attendance.find_or_create_by!(date: Date.new(2025, 1, 5))   # Sunday

# Attendance during an exclusion period (user came in anyway)
Attendance.find_or_create_by!(date: Date.new(2024, 12, 27)) # During winter holidays

puts "Seed data created successfully!"
puts "- #{AttendanceWindow.count} attendance windows"
puts "- #{ExclusionPeriod.count} exclusion periods"
puts "- #{Attendance.count} attendance records"
