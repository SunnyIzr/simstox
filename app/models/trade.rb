class Trade < ApplicationRecord
  belongs_to :portfolio
  delegate :user, :to => :portfolio, :allow_nil => true
  validates :quantity, :ticker, :price_cents, :portfolio_id, presence: true
end
