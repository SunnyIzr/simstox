require 'spec_helper'

describe Position do

   let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }

  before do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})
  end


  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:portfolio_id) {Portfolio.last.id}
  let!(:stock) { FactoryGirl.create(:stock, ticker: 'msft') }
  let!(:quote) { FactoryGirl.create(:quote, price_cents: 7543)}
  let!(:trades) { [ 
    FactoryGirl.create(:trade, stock_id: stock.id, quantity: 10, price_cents: 30_00, portfolio_id: portfolio_id),
    FactoryGirl.create(:trade, stock_id: stock.id, quantity: 15, price_cents: 40_00, portfolio_id: portfolio_id),
    FactoryGirl.create(:trade, stock_id: stock.id, quantity: 20, price_cents: 50_00, portfolio_id: portfolio_id),
    FactoryGirl.create(:trade, stock_id: stock.id, quantity: -17, price_cents: 35_00, portfolio_id: portfolio_id)
    ] }
 
  
  let!(:ticker) {'msft'}

  let!(:position) { Position.new({stock_id: stock.id, portfolio_id: portfolio_id}) }


  it 'returns the portfolio it belongs to' do
    expect(position.portfolio).to eq(Portfolio.last)
  end

  it 'returns current stock price' do
    expect(position.current_price).to eq(73.9200)
  end

  it 'returns trades associated with portfolio/ticker' do
    expect(position.trades).to eq(trades)
  end

  it 'returns quantity' do
    expect(position.quantity).to eq(28)
  end

  it 'returns the average price' do
    average_price = ( ( ( (10 * 30_00) + (15 * 40_00) + (20 * 50_00) ) / 45 ) / 100.00 ).round(2)

    expect(position.average_price).to eq(average_price)
  end

  it 'returns cost basis' do
    average_price = ( ( ( (10 * 30_00) + (15 * 40_00) + (20 * 50_00) ) / 45 ) / 100.00 ).round(2)
    cost_basis = average_price * 28

    expect(position.cost_basis).to eq(cost_basis)
  end

  it 'returns real time market value' do
    mkt_value = 28 * 73.92

    expect(position.market_value_realtime).to eq(mkt_value)
  end

  it 'returns market value' do
    mkt_value = 28 * 75.43

    expect(position.market_value).to eq(mkt_value)
  end

  it 'returns unrealized P&L' do
    average_price = ( ( ( (10 * 30_00) + (15 * 40_00) + (20 * 50_00) ) / 45 ) / 100.00 ).round(2)
    cost_basis = average_price * 28
    mkt_value = 28 * 75.43
    unrealized_pl = ( mkt_value - cost_basis ).round(2)

    expect(position.unrealized_pl).to eq(unrealized_pl)
  end

  it 'returns a return value calculated on open position' do
    average_price = ( ( ( (10 * 30_00) + (15 * 40_00) + (20 * 50_00) ) / 45 ) / 100.00 ).round(2)
    cost_basis = average_price * 28
    mkt_value = 28 * 75.43
    unrealized_pl = mkt_value - cost_basis
    return_value = ( unrealized_pl / cost_basis ).round(4)

    expect(position.return_value).to eq(return_value)
  end

end