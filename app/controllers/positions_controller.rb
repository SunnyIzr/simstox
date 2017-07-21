class PositionsController < ApplicationController
  def index
    @position = Position.new({portfolio_id: params[:portfolio_id], stock_id: params[:stock_id]})
    json_response(@position)
  end
end