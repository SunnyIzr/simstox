module AlphaVantage
  extend self
  BASE_URI = "https://www.alphavantage.co/query?"
  def timeseries(function, symbol, interval = "1min")
    uri = URI.parse(BASE_URI + "function=TIME_SERIES_#{function}&symbol=#{symbol}&interval=#{interval}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}")
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  end

  def latest(ticker, realtime=true)
    function = realtime ? 'intraday' : 'daily'
    timeseries(function,ticker).to_a[1][1].to_a[0][1]['4. close']
  end
end