class Portfolio < ApplicationRecord
  has_many :trades
  belongs_to :user
  validates :name, :cash_cents, :user_id, presence: true
end
