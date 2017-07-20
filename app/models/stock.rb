class Stock < ApplicationRecord
  validates :ticker, presence: true, uniqueness: true
  has_many :trades
  has_many :quotes
end
