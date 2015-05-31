Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: 'static_pages#front'
  get 'home', to: 'videos#index'
  resources :videos, only: :show do
  	collection do
  		get 'search'
  	end
  end
  get 'categories/:id', to: 'categories#show', as: :category

  get 'register', to: 'users#new', as: :register
  resources :users, only: :create
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
