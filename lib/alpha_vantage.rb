require 'net/http'
module AlphaVantage
  extend self
  BASE_URI = "https://www.alphavantage.co/query?"
  def timeseries(function, symbol, interval = "1min")
    # Intraday, Daily, Daily (Adj Close), Weekly, Monthly
    uri = URI.parse(BASE_URI + "function=TIME_SERIES_#{function}&symbol=#{symbol}&interval=#{interval}&apikey=#{ENV['ALPHA_VANTAGE_API_KEY']}")
    res = Net::HTTP.get_response(uri)
    format_response(res.body)
  end

  def format_response(res)
    JSON.parse(res).to_a[1][1].to_a.map do |data|
      time = DateTime.parse(data[0])
      price_cents = ( data[1]['4. close'].to_f * 100 ).to_i
      [time, price_cents]
    end
  end

  def latest(ticker, realtime=true)
    function = realtime ? 'intraday' : 'daily'
    timeseries(function,ticker)[0][1]
  end
end