class Trade < ApplicationRecord
  belongs_to :portfolio
  belongs_to :stock
  delegate :user, :to => :portfolio, :allow_nil => true
  validates :quantity, :stock_id, :price_cents, :portfolio_id, presence: true

  def cost
    ( ( quantity * price_cents ) / 100.00 ).round(2)
  end
end
