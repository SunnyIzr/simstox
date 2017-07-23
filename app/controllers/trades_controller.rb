class TradesController < ApplicationController
  def show
    @trade = Trade.find(params[:id])
    return if authenticate!(@trade.user)

    json_response(@trade)
  end

  def create
    @trade = Trade.new(trade_params)
    return if authenticate!(@trade.user)

    @trade.save!
    json_response(@trade, :created)
  end

  private

  def trade_params
    params.permit(:quantity, :ticker, :price_cents, :portfolio_id, :stock_id, :ticker)
  end
end
