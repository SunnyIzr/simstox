class Quote < ApplicationRecord
  validates :price_cents, :time, :stock_id, presence: true
  belongs_to :stock
end
