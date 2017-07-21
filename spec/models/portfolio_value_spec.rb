require 'spec_helper'

RSpec.describe PortfolioValue, type: :model do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolio) { FactoryGirl.create(:portfolio) }
  let!(:portfolio_value) { FactoryGirl.create(:portfolio_value) }

  it { should validate_presence_of(:cash_cents) }
  it { should validate_presence_of(:market_value_cents) }
  it { should validate_presence_of(:portfolio_id) }
  it { should validate_presence_of(:time) }
  it { should belong_to(:portfolio) }

  it 'returns market_value in dollars' do 
    expect(portfolio_value.market_value).to eq(124830.38)
  end

  it 'returns cash in dollars' do
    expect(portfolio_value.cash).to eq(75000.00)
  end

  it 'returns total value in dollars' do
    total_value = 75000.00 + 124830.38
    expect(portfolio_value.total_value).to eq(total_value)
  end
end
