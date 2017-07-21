class Portfolio < ApplicationRecord
  has_many :trades
  has_many :stocks, through: :trades
  has_many :portfolio_values
  belongs_to :user
  validates :name, :cash_cents, :user_id, :starting_balance_cents, presence: true

  def cash
    ( cash_cents / 100.00 ).round(2)
  end

  def starting_balance
    ( starting_balance_cents / 100.00 ).round(2)
  end

  def tickers
    stocks.pluck(:ticker).uniq
  end

  def positions
    stocks.uniq.map do |stock|
      Position.new({stock_id: stock.id, portfolio_id: id})
    end
  end

  def cost_basis
    positions.map{ |position| position.cost_basis }.sum
  end

  def market_value
    (positions.map{ |position| position.market_value }.sum).round(2)
  end

  def market_value_real_time
    (positions.map{ |position| position.market_value_real_time }.sum).round(2)
  end

  def total_value
    ( market_value + cash ).round(2)
  end

  def unrealized_pl
    (market_value - cost_basis).round(2)
  end

  def total_pl
    ( total_value - starting_balance ).round(2)
  end

  def return
    ( total_pl / starting_balance_cents ).round(4)
  end

end
