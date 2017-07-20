class CreatePortfolioValues < ActiveRecord::Migration[5.1]
  def change
    create_table :portfolio_values do |t|
      t.integer :cash_cents, null: false
      t.integer :market_value_cents, null: false
      t.belongs_to :portfolio, null: false
      t.datetime :time, null: false
      t.timestamps
    end
  end
end
