class PortfolioValue < ApplicationRecord
  validates :cash_cents, :market_value_cents, :portfolio_id, :time, presence: true
  belongs_to :portfolio
end
