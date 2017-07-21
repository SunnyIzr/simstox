class Stock < ApplicationRecord
  validates :ticker, presence: true, uniqueness: true
  has_many :trades
  has_many :quotes

  def get_historical_quotes
    AlphaVantage.timeseries('daily', ticker)
  end

  def get_historical_quotes_realtime
    AlphaVantage.timeseries('intraday', ticker)
  end

  def save_historical_quotes
    quotes = get_historical_quotes
    quotes.each do |quote|
      Quote.create(time: quote[0], price_cents: quote[1], stock_id: self.id)
    end
  end
end
