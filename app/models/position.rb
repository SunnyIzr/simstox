class Position
  attr_reader :portfolio_id, :stock_id

  def initialize(args)
    @stock_id = args.fetch(:stock_id)
    @portfolio_id = args.fetch(:portfolio_id)
  end

  def portfolio
    Portfolio.find_by(id: portfolio_id.to_i)
  end

  def stock
    Stock.find_by(id: stock_id)
  end

  def ticker
    stock.ticker
  end

  def current_price
    ( AlphaVantage.latest(stock.ticker) / 100.00 ).round(2)
  end

  def close_price
    Quote.where(stock_id: stock_id).last.price
  end

  def trades
    portfolio.trades.where(stock_id: stock.id)
  end

  def quantity
    trades.pluck(:quantity).sum
  end

  def average_price
    buy_qty = 0
    total_cost = 0
    trades.map do |trade| 
      if trade.quantity > 0
        buy_qty += trade.quantity
        total_cost += trade.cost
      end
    end
    ( total_cost / buy_qty ).round(2)
  end

  def cost_basis
     average_price * quantity
  end

  def market_value
    (quantity * close_price).round(2)
  end

  def market_value_realtime
    (quantity * current_price).round(2)
  end

  def unrealized_pl
    (market_value - cost_basis).round(2)
  end

  def return
    ( unrealized_pl / cost_basis ).round(4)
  end

end