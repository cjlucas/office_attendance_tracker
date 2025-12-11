class AttendanceWindowSerializer
  MODEL_FIELDS = %w[
    id
    start_date
    end_date
    days_remaining
    created_at
    updated_at
  ]

  SERIALIZER_FIELDS = %w[
    attendance_count
  ]

  def initialize(window)
    @window = window
  end

  def as_json
    model_fields = MODEL_FIELDS.each_with_object({}) do |field, acc|
      acc[field] = @window.send(field)
    end

    serializer_fields = SERIALIZER_FIELDS.each_with_object({}) do |field, acc|
      acc[field] = send(field)
    end

    model_fields.merge(serializer_fields)
  end

  def attendance_count
    Attendance.where(date: @window.start_date..@window.end_date).count
  end
end
