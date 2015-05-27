Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'videos/:id', to: 'videos#show', as: :video
  get 'categories/:id', to: 'categories#show', as: :category
end
