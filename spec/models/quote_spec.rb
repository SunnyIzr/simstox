require 'spec_helper'

RSpec.describe Quote, type: :model do
  let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }

  before do
    stub_request(:get, /www.alphavantage.co/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: response_data , headers: {})
  end

  let!(:stock) {FactoryGirl.create(:stock)}

  it { should validate_presence_of(:price_cents) }
  it { should validate_presence_of(:time) }
  it { should validate_presence_of(:stock_id) }
  it { should belong_to(:stock)}

  it 'should not save quote where time/stock combination is the same' do
    time = Time.new
    
    FactoryGirl.create(:quote, stock_id: stock.id, time: time)
    quote = FactoryGirl.build(:quote, stock_id: stock.id, time: time)

    expect(quote).to_not be_valid
    expect(quote.errors.full_messages[0]).to eq('Stock has already had Quote pulled for that time')
  end
end
