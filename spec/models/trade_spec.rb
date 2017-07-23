require 'spec_helper'

describe Trade do
  let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }

  before do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})
  end

  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 1, cash_cents: 1_000_00)}
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

    context 'when new trade is executed' do
    
    it 'should not be able to place a sell order if there is not enough inventory' do
      new_trade = FactoryGirl.build(:trade, stock_id: Stock.last.id, quantity: -15, price_cents: 30_00, portfolio_id: portfolio_id)
      expect(new_trade).to_not be_valid
      expect(new_trade.errors.full_messages[0]).to eq('Portfolio does not have sufficient inventory to cover this trade')
    end

    it 'should not be able to place a buy order if there is not enough cash' do
      new_trade = FactoryGirl.build(:trade, stock_id: Stock.last.id, quantity: 5000, price_cents: 30_00, portfolio_id: portfolio_id)
      expect(new_trade).to_not be_valid
      expect(new_trade.errors.full_messages[0]).to eq('Portfolio does not have sufficient funds to cover this trade')
    end

    it 'reduces cash from portfolio' do
      expect(trade.portfolio.cash_cents).to eq(700_00)
    end

    it 'executes new trade given a ticker' do
      trade = Trade.new(quantity: 10, price_cents: 4500, portfolio_id: Portfolio.last.id,ticker: "msft")

      expect(trade).to be_valid
    end

    it 'creates new stock if it does not exist' do
      trade = Trade.new(quantity: 10, price_cents: 4500, portfolio_id: Portfolio.last.id,ticker: "AAPL")

      expect(trade).to be_valid
      expect(Stock.last.ticker).to eq('AAPL')
    end

  end

end
