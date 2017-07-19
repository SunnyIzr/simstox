class StocksController < ApplicationController

  def historical
    json_response(AlphaVantage.timeseries('monthly',params[:ticker]).to_a[1][1])
  end

end