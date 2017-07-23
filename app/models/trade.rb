class Trade < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  delegate :user, :to => :portfolio, :allow_nil => true
  before_save :reduce_cash
  validates_with TradeValidator
  validates :quantity, :stock_id, :price_cents, :portfolio_id, presence: true

  def cost
    ( ( quantity * price_cents ) / 100.00 ).round(2)
  end

  def ticker
    stock.ticker
  end

  def price
    ( price_cents / 100.00 ).round(2)
  end

  def position
    Position.new(stock_id: stock_id, portfolio_id: portfolio_id)
  end

  def reduce_cash
    new_cash_cents = portfolio.cash_cents - ( quantity * price_cents )
    portfolio.update!(cash_cents: new_cash_cents)
  end

  def ticker=(ticker)
    if stock_id.nil?
      stock = Stock.find_or_create_by(ticker: ticker)
      self.stock_id = stock.id
    end
  end

end
