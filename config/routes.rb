Rails.application.routes.draw do
  resources :trades, only: [:show, :create]
  resources :portfolios, only: [:show, :create, :update, :destroy]
end
