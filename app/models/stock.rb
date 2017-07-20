class Stock < ApplicationRecord
  validates :ticker, presence: true
  has_many :trades
  has_many :quotes
end
