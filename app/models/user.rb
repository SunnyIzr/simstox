class User < ApplicationRecord
  validates :username, :first_name, :last_name, presence: true
  has_many :portfolios
  has_many :trades, through: :portfolios
end
