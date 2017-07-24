class PortfolioSerializer < ActiveModel::Serializer
  attributes :id, :name, :cash, :market_value, :total_value, :return_value, :total_pl, :recent_trades, :positions, :historical_data

  def recent_trades
    object.trades.last(5).reverse.collect{ |trade| {
      quantity: trade.quantity,
      price: trade.price,
      ticker: trade.ticker,
      created_at: trade.created_at
    }}
  end
  def positions
    object.positions.collect{|position| { 
      stock_id: position.stock_id,
      portfolio_id: position.portfolio_id,
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
  def return_value
    ( object.return_value * 100 ).round(2)
  end
end
