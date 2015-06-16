Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'static_pages#front'
  get 'home', to: 'videos#index'
  
  resources :videos, only: :show do
    collection do
      get 'search'
    end
    resources :reviews, only: :create
  end
  get 'categories/:id', to: 'categories#show', as: :category

  get 'register', to: 'users#new', as: :register
  resources :users, only: [:create, :show]
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'my_queue', to: 'queue_items#index'
  patch 'queue_items', to: 'queue_items#update'
  resources :queue_items, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]
  get 'people', to: 'relationships#index'

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'confirm_password_reset', to: 'forgot_passwords#confirm_reset'
  get 'reset_password/:id', to: 'forgot_passwords#edit', as: :reset_password
  patch 'update_password', to: 'forgot_passwords#update'
  get 'expired_token', to: 'forgot_passwords#invalid_token'
  resources :forgot_passwords, only: [:create]
  
end
