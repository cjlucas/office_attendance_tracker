class Api::AttendanceWindowsController < ActionController::API
  def active
    windows = AttendanceWindow.active.map do |window|
      AttendanceWindowSerializer.new(window)
    end

    render json: windows
  end
end
