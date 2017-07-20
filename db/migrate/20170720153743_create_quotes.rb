class CreateQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :quotes do |t|
      t.integer :price_cents, null: false
      t.datetime :time, null: false
      t.belongs_to :stock, null: false
      t.timestamps
    end
  end
end
