Rails.application.routes.draw do
  get 'home/index'
  resources :logs_processamentos, only: [:index, :show]
  resources :clientes, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :arquivos_teste, only: [:index, :create]
  resources :arquivos_emails, only: [:index, :new, :create, :show]


  # Defines the root path route ("/")
  root 'home#index'

end
