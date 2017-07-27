class AddDefaultCashToPortfolios < ActiveRecord::Migration[5.1]
  def change
    change_column :portfolios, :cash_cents, :integer, default: 100_000_00
  end
end
