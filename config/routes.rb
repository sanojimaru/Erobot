Erobot::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  root to: 'pages#index'
  resources :images, only: [:index]
  resources :pages, only: [:index, :show]
  resources :image2ches, only: [:index]
end
