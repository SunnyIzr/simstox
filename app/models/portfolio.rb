class Portfolio < ApplicationRecord
  has_many :trades
  has_many :stocks, through: :trades
  belongs_to :user
  validates :name, :cash_cents, :user_id, :starting_balance_cents, presence: true

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

  def total_value
    market_value + ( cash_cents / 100 ).round(2)
  end

  def unrealized_pl
    (market_value - cost_basis).round(2)
  end

  def total_pl
    ( total_value - ( starting_balance_cents / 100.00 ) ).round(2)
  end

  def return
    ( total_pl / ( starting_balance_cents / 100 ) ).round(4)
  end

end
