class Position
  attr_reader :portfolio_id, :ticker

  def initialize(args)
    @ticker = args.fetch(:ticker)
    @portfolio_id = args.fetch(:portfolio_id)
  end

  def portfolio
    Portfolio.find_by(id: portfolio_id)
  end

  def current_price
    AlphaVantage.latest(ticker)
  end

  def trades
    portfolio.trades.where(ticker: ticker)
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
    (quantity * current_price).round(2)
  end

  def unrealized_pl
    (market_value - cost_basis).round(2)
  end

  def return
    ( unrealized_pl / cost_basis ).round(4)
  end

end