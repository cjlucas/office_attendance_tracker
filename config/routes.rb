Rails.application.routes.draw do
  root "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :attendances, only: [ :create ]

    resources :attendance_windows, only: [] do
      get :active, on: :collection
    end
  end
end
