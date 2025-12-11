Rails.application.config.to_prepare do
  ActiveRecord::Type.register(:strict_date, Types::Date)
end
