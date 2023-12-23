Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "chats#index"

  resources :chats, only: [:index, :new, :create, :show] do
    resources :messages, only: [:create, :show]
  end

  namespace :api do
    resources :chats, only: [:index] do
      resources :messages, only: [:create]
    end
  end
end
