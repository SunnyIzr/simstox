class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :name, :cash, :market_value, :total_value, :return_value, :recent_trades, :positions, :historical_data

  def recent_trades
    object.trades.limit(5).collect{ |trade| {
      quantity: trade.quantity,
      price: trade.price,
      ticker: trade.ticker,
      created_at: trade.created_at
    }}
  end
  def positions
    object.positions.collect{|position| { 
      ticker: position.ticker,
      quantity: position.quantity,
      average_price: position.average_price,
      close_price: position.close_price,
      market_value: position.market_value,
      unrealized_pl: position.unrealized_pl
    }}
  end
  def historical_data
    object.portfolio_values.collect{|quote| {
      total_value: quote.total_value,
      time: quote.time
    }}
  end
end
