class StocksController < ApplicationController

  def historical
    json_response(AlphaVantage.timeseries('intraday',params[:ticker]))
  end

end