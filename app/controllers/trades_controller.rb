class TradesController < ApplicationController
  def show
    @trade = Trade.find(params[:id])
    json_response(@trade)
  end

  def create
    @trade = Trade.create!(trade_params)
    json_response(@trade, :created)
  end

  private

  def trade_params
    params.permit(:quantity, :ticker, :price_cents, :portfolio_id)
  end
end
