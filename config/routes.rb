Rails.application.routes.draw do

  get 'microposts/create'
  get 'microposts/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'signup', to: 'users#new'
  resources :users
  resources :microposts, only: [:create, :destroy]
  
end
