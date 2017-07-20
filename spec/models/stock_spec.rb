require 'spec_helper'

RSpec.describe Stock, type: :model do
  let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }
  let!(:stock) { FactoryGirl.create(:stock, ticker: 'msft') }

  it { should validate_presence_of(:ticker) }
  it { should have_many(:trades) }
  it { should have_many(:quotes) }

  it 'gets and saves down historical quotes' do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})

    stock.save_historical_quotes

    expect(Quote.all.size).to eq(6)
    expect(Quote.last.stock).to eq(stock)
    expect(Quote.first.price_cents).to eq(7392)
    expect(Quote.last.price_cents).to eq(7391)
  end
end
