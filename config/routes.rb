Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "trains#index"
  resources :trains, only: [:index]
  
end
