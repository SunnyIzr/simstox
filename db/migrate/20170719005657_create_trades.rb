class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.integer :quantity, null: false
      t.string :ticker, null: false
      t.integer :price_cents, null: false
      t.belongs_to :portfolio, null: false
      t.timestamps
    end
  end
end
