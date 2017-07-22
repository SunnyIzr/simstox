class PositionSerializer < ActiveModel::Serializer
  attributes :ticker, :return, :quantity, :average_price, :close_price, :intraday

  def ticker
    object.ticker
  end

  def return_value
    object.return_value
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

  def intraday
    object.stock.get_historical_quotes_realtime
  end
end
