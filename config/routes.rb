Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Merchants
  get "/api/v1/merchants", to: "api/v1/merchants#index"
<<<<<<< HEAD
  post "/api/v1/merchants", to: "api/v1/merchants#create" 
  
  # Items
  get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  post "/api/v1/items", to: "api/v1/items#create"
  delete "/api/v1/items/:id", to: "api/v1/items#destroy"
=======

  get "/api/v1/merchants", to: "api/v1/merchants#index"


  patch "/api/v1/items/:id", to: "api/v1/items#update"

>>>>>>> 73bcb37 (Add the update method and private item_params method to the items_controller, add PATCH route for updating items in API, and made merchant singular in the item model.)
  # Defines the root path route ("/")
  # root "posts#index"
end
