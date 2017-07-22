class PositionSerializer < ActiveModel::Serializer
  attributes :porfolio_name, :ticker, :return_value, :quantity, :average_price, :close_price, :unrealized_pl, :intraday

  def portfolio_name
    object.portfolio_name
  end

  def ticker
    object.ticker
  end

  def return_value
    ( object.return_value * 100 ).round(2)
  end

  def quantity
    object.quantity
  end

  def average_price
    object.average_price
  end

  def close_price
    object.close_price
  end

  def unrealized_pl
    object.unrealized_pl
  end

  def intraday
    object.stock.get_historical_quotes_realtime.map { |quote| (quote[1] / 100.00).round(2) }
  end
end
