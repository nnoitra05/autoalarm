Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "trains#index"
  resources :bookmarks, only: [:show, :create, :edit, :update]
  resources :calendars, only: [:show, :edit, :create]
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :trains, only: [:index] do
    collection do
      get :search
      get :sandbox
    end
  end
end
