Rails.application.routes.draw do
  resources :trades, only: [:show, :create]
  resources :portfolios, only: [:show, :create, :update, :destroy]

  get '/stocks/:ticker/historical' => 'stocks#historical'

  get '/portfolios/:portfolio_id/stocks/:stock_id' => 'positions#index'
  
end
