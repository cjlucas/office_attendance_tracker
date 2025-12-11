class AttendanceWindow < ApplicationRecord
  attribute :start_date, :strict_date
  attribute :end_date, :strict_date

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_on_or_after_start_date

  # Scopes
  scope :active, -> {
    today = Date.today
    where("start_date <= ? AND end_date >= ?", today, today)
  }

  def days_remaining
    (end_date - Date.today).to_i + 1
  end

  def attendances
    Attendance.where(date: start_date..end_date)
  end

  # Validators
  def end_date_on_or_after_start_date
    if end_date < start_date
      errors.add(:end_date, "must be on or after start date")
    end
  end
end
