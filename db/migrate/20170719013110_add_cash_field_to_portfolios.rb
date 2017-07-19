class AddCashFieldToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :cash_cents, :integer, null: false
  end
end
