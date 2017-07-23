class User < ApplicationRecord
  validates :username, :first_name, :last_name, :password_digest, presence: true
  validates :username, uniqueness: true
  has_many :portfolios
  has_many :trades, through: :portfolios
  before_save :downcase_username
  has_secure_password

  def downcase_username
    self.username = self.username.delete(' ').downcase
  end
end
