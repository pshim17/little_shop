Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Merchants
  get "/api/v1/merchants", to: "api/v1/merchants#index"
  post "/api/v1/merchants", to: "api/v1/merchants#create" 
  patch "/api/v1/merchants/:id", to: "api/v1/merchants#update"
  delete "/api/v1/merchants/:id", to: "api/v1/merchants#destroy"
  get "/api/v1/merchants/find", to: "api/v1/merchants/search#show"

  # Items
  get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  post "/api/v1/items", to: "api/v1/items#create"
  patch "/api/v1/items/:id", to: "api/v1/items#update"
  delete "/api/v1/items/:id", to: "api/v1/items#destroy"
  get "/api/v1/items/find_all", to: "api/v1/items/search#show"

  # Customers
  get "/api/v1/merchants/customers", to: "api/v1/merchants/customers#index"
  get "/api/v1/merchants/:merchant_id/customers", to: "api/v1/merchants/customers#customers_by_merchant"

  
  # Defines the root path route ("/")
  # root "posts#index"
end
