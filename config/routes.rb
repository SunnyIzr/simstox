Rails.application.routes.draw do
  resources :trades, only: [:show, :create]
  resources :portfolios, only: [:show, :create, :update, :destroy]
  resources :users, only: [:index, :create] do
    collection do
      post 'login'
    end
  end

  get '/user' => 'users#show'

  get '/stocks/:ticker/historical' => 'stocks#historical'

  get '/portfolios/:portfolio_id/stocks/:stock_id' => 'positions#show'
  
end
