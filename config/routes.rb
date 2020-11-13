Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: "trains#index"
  resources :bookmarks, only: [:edit, :show]
  resources :calendars, only: [:show, :edit, :create]
  resources :trains, only: :index do
    collection do
      get :search
    end
  end
end
