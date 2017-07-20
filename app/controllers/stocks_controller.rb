class StocksController < ApplicationController

  def historical
    json_response(AlphaVantage.timeseries('monthly',params[:ticker]))
  end

end