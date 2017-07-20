require 'spec_helper'

describe Portfolio do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolio) { FactoryGirl.create(:portfolio) }
  let!(:portfolio_id) {portfolio.id}
  let!(:trades) { [ FactoryGirl.create(:trade, ticker: 'msft', quantity: 10, price_cents: 30_00, portfolio_id: portfolio_id), FactoryGirl.create(:trade, ticker: 'msft', quantity: 15, price_cents: 40_00, portfolio_id: portfolio_id), FactoryGirl.create(:trade, ticker: 'msft', quantity: 20, price_cents: 50_00, portfolio_id: portfolio_id), FactoryGirl.create(:trade, ticker: 'msft', quantity: -17, price_cents: 35_00, portfolio_id: portfolio_id)] }
  

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cash_cents) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:starting_balance_cents) }
  it { should have_many(:trades) }
  it { should belong_to(:user) }

  

  it 'returns a unique list of tickers' do
    expect(portfolio.tickers).to eq(['msft'])
  end

  it 'returns a list of positions' do
    expect(portfolio.positions.size).to eq(1)
    expect(portfolio.positions[0]).to be_an_instance_of(Position)
    expect(portfolio.positions[0].ticker).to eq('msft')
    expect(portfolio.positions[0].portfolio_id).to eq(portfolio_id)
  end

  it 'returns cost basis'

  it 'returns market value'

  it 'returns total value'

  it 'returns unrealized P&L'

  it 'returns a return value calculated on open position'

end
