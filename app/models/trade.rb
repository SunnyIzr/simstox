class Trade < ApplicationRecord
  belongs_to :portfolio
  validates :quantity, :ticker, :price_cents, :portfolio_id, presence: true
end
