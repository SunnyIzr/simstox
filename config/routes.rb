Rails.application.routes.draw do
  resources :trades, only: [:show, :create]
end
