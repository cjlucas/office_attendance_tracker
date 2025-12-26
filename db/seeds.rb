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

today = Date.current

puts "Seeding attendance windows..."

# Generate rolling 3-month windows from 1 year ago to 1 year in the future
# A new window starts on the 1st of each month
window_start = (today - 1.year).beginning_of_month
window_end = (today + 1.year).beginning_of_month

(window_start..window_end).select { |d| d.day == 1 }.each do |start_date|
  end_date = start_date + 3.months - 1.day

  AttendanceWindow.find_or_create_by!(start_date: start_date) do |window|
    window.end_date = end_date
  end
end

puts "Seeding exclusion periods..."

# Winter holidays (year-end shutdown) - last week of December
# Create for last year, this year, and next year
[ today.year - 1, today.year, today.year + 1 ].each do |year|
  seed_exclusion_period(Date.new(year, 12, 24), Date.new(year, 12, 31))
end

# Company-wide events (hypothetical all-hands in mid-January)
[ today.year - 1, today.year, today.year + 1 ].each do |year|
  seed_exclusion_period(Date.new(year, 1, 18), Date.new(year, 1, 20))
end

# Summer shutdowns (first week of July)
[ today.year - 1, today.year, today.year + 1 ].each do |year|
  seed_exclusion_period(Date.new(year, 7, 1), Date.new(year, 7, 7))
end

puts "Seeding attendance records..."

# Generate attendance for past dates only (last 6 months up to yesterday)
attendance_start = today - 6.months
attendance_end = today - 1.day

seed_attendance_for_range(attendance_start, attendance_end)

# Add a couple weekend attendances (rare examples) in the past 3 months
past_saturday = today - 8.weeks
past_saturday = past_saturday - (past_saturday.wday - 6) % 7 # Find the most recent Saturday
Attendance.find_or_create_by!(date: past_saturday) if past_saturday < today

past_sunday = today - 4.weeks
past_sunday = past_sunday - past_sunday.wday # Find the most recent Sunday
Attendance.find_or_create_by!(date: past_sunday) if past_sunday < today

# Attendance during an exclusion period (user came in anyway)
# Find a winter holiday period in the past
last_winter = Date.new(today.year - 1, 12, 27)
Attendance.find_or_create_by!(date: last_winter) if last_winter < today

puts "Seed data created successfully!"
puts "- #{AttendanceWindow.count} attendance windows"
puts "- #{ExclusionPeriod.count} exclusion periods"
puts "- #{Attendance.count} attendance records"
