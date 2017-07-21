class PortfolioValue < ApplicationRecord
  validates :cash_cents, :market_value_cents, :portfolio_id, :time, presence: true
  belongs_to :portfolio

  def market_value
    ( market_value_cents / 100.00 ).round(2)
  end

  def cash
    ( cash_cents / 100.00 ).round(2)
  end

  def total_value
    market_value + cash_cents
  end
end
