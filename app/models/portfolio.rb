class Portfolio < ApplicationRecord
  has_many :trades
  validates :name, :cash_cents, presence: true
end
