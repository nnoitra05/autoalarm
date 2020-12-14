Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "trains#index"
  resources :bookmarks, only: [:index, :show, :create, :edit, :update, :destroy] do
    member do
      get :register
    end
    collection do
      post :register_without
    end
  end
  resources :calendars, only: [:show, :edit, :create, :destroy]
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :trains, only: [:index] do
    collection do
      get :search
      get :sandbox
    end
  end
end
