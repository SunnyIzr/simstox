Rails.application.routes.draw do
  resources :trades, only: [:show, :create]
  resources :portfolios, only: [:show, :create, :update, :destroy]
  resources :users, only: [:show, :index, :create]

  get '/stocks/:ticker/historical' => 'stocks#historical'

  get '/portfolios/:portfolio_id/stocks/:stock_id' => 'positions#show'
  
end
