class Api::AttendanceWindowsController < ActionController::API
  def active
    render json: AttendanceWindowSerializer.render(AttendanceWindow.active)
  end
end
