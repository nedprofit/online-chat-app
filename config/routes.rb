Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "chats#index"

  resources :users do
    get 'settings', on: :member, to: 'users#edit', as: 'edit_settings'
    patch 'settings', on: :member, to: 'users#update', as: 'update_settings'
  end

  resources :chats, only: [:index, :new, :create, :show] do
    resources :messages, only: [:create, :show]
  end

  namespace :api do
    resources :chats, only: [:index] do
      resources :messages, only: [:create]
    end
  end
end
