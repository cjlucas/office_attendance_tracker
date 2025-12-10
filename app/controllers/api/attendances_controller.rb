class Api::AttendancesController < Api::BaseController
  def create
    @attendance = Attendance.new(date: Date.today)

    if @attendance.save
      head :created
    elsif @attendance.errors.of_kind?(:date, :taken)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
