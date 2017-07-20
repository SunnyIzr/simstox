require 'spec_helper'

describe Portfolio do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolio) { FactoryGirl.create(:portfolio, cash_cents: 50_000_00) }
  let!(:portfolio_id) {portfolio.id}
  let!(:stocks) { [ 
    FactoryGirl.create(:stock, ticker: 'msft'), 
    FactoryGirl.create(:stock, ticker: 't'), 
    FactoryGirl.create(:stock, ticker: 'ko')
  ]}
  let!(:trades) { [ 
    FactoryGirl.create(:trade, stock_id: stocks[0].id, quantity: 10, price_cents: 30_00, portfolio_id: portfolio_id), 
    FactoryGirl.create(:trade, stock_id: stocks[0].id, quantity: 20, price_cents: 50_00, portfolio_id: portfolio_id), 
    FactoryGirl.create(:trade, stock_id: stocks[1].id, quantity: 15, price_cents: 40_00, portfolio_id: portfolio_id), 
    FactoryGirl.create(:trade, stock_id: stocks[0].id, quantity: -17, price_cents: 35_00, portfolio_id: portfolio_id),
    FactoryGirl.create(:trade, stock_id: stocks[2].id, quantity: 30, price_cents: 25_00, portfolio_id: portfolio_id)
  ]}
  let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }
  

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:cash_cents) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:starting_balance_cents) }
  it { should have_many(:trades) }
  it { should have_many(:stocks) }
  it { should have_many(:portfolio_values) }
  it { should belong_to(:user) }

  

  it 'returns a unique list of tickers' do
    expect(portfolio.tickers).to eq(['msft', 't', 'ko'])
  end

  it 'returns a list of positions' do
    expect(portfolio.positions.size).to eq(3)
    expect(portfolio.positions[0]).to be_an_instance_of(Position)
    expect(portfolio.positions[0].ticker).to eq('msft')
    expect(portfolio.positions[0].portfolio_id).to eq(portfolio_id)
  end

  it 'returns cost basis' do
    msft_cost = ( ((30.00*10) + (50.00*20)) / 30 ).round(2) * 13
    ko_cost = 25.00 * 30
    t_cost = 40.00 * 15
    total_cost = msft_cost + ko_cost + t_cost

    expect(portfolio.cost_basis).to eq(total_cost)
  end

  it 'returns market value' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    mkt_value = 58 * 73.92

    expect(portfolio.market_value).to eq(mkt_value)
  end

  it 'returns total value' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    total_value = ( 58 * 73.92 ) + 50_000

    expect(portfolio.total_value).to eq(total_value)
  end

  it 'returns unrealized P&L' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    mkt_value = ( 58 * 73.92 )
    msft_cost = ( ((30.00*10) + (50.00*20)) / 30 ).round(2) * 13
    ko_cost = 25.00 * 30
    t_cost = 40.00 * 15
    total_cost = msft_cost + ko_cost + t_cost

    unrealized_pl = ( mkt_value - total_cost ).round(2)

    expect(portfolio.unrealized_pl).to eq(unrealized_pl)
  end

  it 'returns a total P&L on a portfolio' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    total_value = ( 58 * 73.92 ) + 50_000

    total_pl = total_value - 100_000

    expect(portfolio.total_pl).to eq(total_pl)
  end

  it 'returns a return value calculated on open position' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    total_value = ( 58 * 73.92 ) + 50_000

    total_pl = total_value - 100_000

    return_value = (total_pl / 100_000).round(4)

    expect(portfolio.return).to eq(return_value)
  end

end
