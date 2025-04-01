Rails.application.routes.draw do
  get "home/index"
  get "gallery/index"
  resources :events
  devise_for :users
  resources :gallery, only: [ :index ] do
    collection do
      get "search", to: "gallery#index"
    end
  end
  resources :bookings do
    member do
      patch :cancel  # ✅ Route for cancelling a booking
    end
  end


  resources :events, only: [ :index, :show ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "gallery", to: "gallery#index"
  resources :events do
    resources :bookings, only: [ :new, :create ]
  end

  authenticate :user, ->(u) { u.admin? } do
    resources :events, only: [ :new, :create, :edit, :update, :destroy ]
  end

  resources :events do
    resources :bookings, only: [ :create, :show ]
  end

  resources :bookings do
    resources :payments, only: [ :new, :create ] # Nested payments under bookings
  end
  resources :bookings, only: [ :index, :show ]  # Add this line to access user's booking history

  root "home#index"
  resources :bookings, only: [ :show ]
  get "payment/:id", to: "payments#new", as: :payment
  post "payment/:id", to: "payments#create", as: :process_payment  # ✅ Fix: Add this line


  authenticate :user, ->(u) { u.admin? } do
    get "admin/dashboard", to: "admin#dashboard"
  end
end
