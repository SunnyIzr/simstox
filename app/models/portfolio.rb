class Portfolio < ApplicationRecord
  has_many :trades
  validates :name, presence: true
end
