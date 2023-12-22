Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "chats#index"
  resources :chats, only: [:index, :new, :create]
end
