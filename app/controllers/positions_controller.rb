class PositionsController < ApplicationController
  def show
    begin
      @position = Position.new({portfolio_id: params[:portfolio_id], stock_id: params[:stock_id]})
      json_response(@position)
    rescue NoMethodError
      json_response({ message: 'Couldn\'t find Position' }, :not_found)
    end
  end
end