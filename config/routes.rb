Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  resources :videos, only: :show do
  	collection do
  		get 'search'
  	end
  end
  get 'categories/:id', to: 'categories#show', as: :category
  
end
