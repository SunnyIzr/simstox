class Quote < ApplicationRecord
  validates :price_cents, :time, :stock_id, presence: true
  belongs_to :stock

  def price
    ( price_cents / 100.00 ).round(2)
  end
end
