Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  # resources :fabs
  resources :users do
    resources :fabs
  end
end
