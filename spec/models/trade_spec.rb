require 'spec_helper'

describe Trade do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 1)}
  let!(:portfolio_id) {Portfolio.last.id}
  let!(:stock) {FactoryGirl.create(:stock, ticker: 'msft')}
  let!(:trade) { FactoryGirl.create(:trade, stock_id: Stock.last.id, quantity: 10, price_cents: 30_00, portfolio_id: portfolio_id) }

  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:stock_id) }
  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:portfolio_id) }
  it { should belong_to(:portfolio) }
  it { should belong_to(:stock) }

  it 'returns cost' do
    cost = ( ( 10 * 30_00 ) / 100.00 ).round(2)

    expect(trade.cost).to eq(cost)
  end

  it 'returns ticker' do
    expect(trade.ticker).to eq('msft')
  end

  it 'returns price in dollars' do
    expect(trade.price).to eq(30.00)
  end
end
