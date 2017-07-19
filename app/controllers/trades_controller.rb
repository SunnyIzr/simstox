class TradesController < ApplicationController
  def show
    @trade = Trade.find(params[:id])
    json_response(@trade)
  end
end
