class ConnectStocksToTrades < ActiveRecord::Migration[5.1]
  def change
    remove_column :trades, :ticker
    add_reference :trades, :stock, null: false
  end
end
