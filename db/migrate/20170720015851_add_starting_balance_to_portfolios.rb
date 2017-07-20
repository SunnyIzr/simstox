class AddStartingBalanceToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :starting_balance_cents, :integer, default: 100_000_00, null: false
  end
end
