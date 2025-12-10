class ExclusionPeriod < ApplicationRecord
  def self.single_day(date)
    new(start_date: date, end_date: date)
  end

  def self.in_range(start:, end:)
  end

  def days
    self.start_date
  end
end
