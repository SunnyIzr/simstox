class Trade < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  delegate :user, :to => :portfolio, :allow_nil => true
  validates :quantity, :stock_id, :price_cents, :portfolio_id, presence: true
  validates_with TradeValidator

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
    ( quantity * price_cents )
  end

end
