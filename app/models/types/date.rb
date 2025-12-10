module Types
  class Date < ActiveRecord::Type::Date
    def cast(value)
      return nil if value.nil?
      return value if value.is_a?(::Date)

      if value.is_a?(String)
        ::Date.parse(value)
      else
        raise ArgumentError, "date must be a Date or parseable string, got #{value.class}"
      end
    rescue ArgumentError, TypeError => e
      raise ArgumentError, "invalid date string: #{value.inspect} - #{e.message}"
    end
  end
end
