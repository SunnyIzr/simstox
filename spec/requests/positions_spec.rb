require 'spec_helper'

RSpec.describe "Positions API", type: :request do
  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let(:portfolio_id) {Portfolio.last.id}
  let!(:stock) { FactoryGirl.create(:stock, ticker: 'msft') }
  let(:stock_id) {Stock.last.id}
  let!(:quote) { FactoryGirl.create(:quote, price_cents: 7543)}
  let!(:trades) { [ 
      FactoryGirl.create(:trade, stock_id: stock.id, quantity: 10, price_cents: 30_00, portfolio_id: portfolio_id)
      ]}
  let!(:response_data) { "{\n    \"Meta Data\": {\n        \"1. Information\": \"Intraday (1min) prices and volumes\",\n        \"2. Symbol\": \"msft\",\n        \"3. Last Refreshed\": \"2017-07-19 15:31:00\",\n        \"4. Interval\": \"1min\",\n        \"5. Output Size\": \"Compact\",\n        \"6. Time Zone\": \"US/Eastern\"\n    },\n    \"Time Series (1min)\": {\n        \"2017-07-19 15:31:00\": {\n            \"1. open\": \"73.9300\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9200\",\n            \"5. volume\": \"37870\"\n        },\n        \"2017-07-19 15:30:00\": {\n            \"1. open\": \"73.9200\",\n            \"2. high\": \"73.9350\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9300\",\n            \"5. volume\": \"14417\"\n        },\n        \"2017-07-19 15:29:00\": {\n            \"1. open\": \"73.9333\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9200\",\n            \"4. close\": \"73.9250\",\n            \"5. volume\": \"20945\"\n        },\n        \"2017-07-19 15:28:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9400\",\n            \"3. low\": \"73.9100\",\n            \"4. close\": \"73.9350\",\n            \"5. volume\": \"27593\"\n        },\n        \"2017-07-19 15:27:00\": {\n            \"1. open\": \"73.9100\",\n            \"2. high\": \"73.9300\",\n            \"3. low\": \"73.9000\",\n            \"4. close\": \"73.9100\",\n            \"5. volume\": \"19716\"\n        },\n        \"2017-07-19 15:26:00\": {\n            \"1. open\": \"73.9000\",\n            \"2. high\": \"73.9200\",\n            \"3. low\": \"73.8900\",\n            \"4. close\": \"73.9118\",\n            \"5. volume\": \"29158\"\n        }\n    }\n}" }

  describe "GET /portfolios/:portfolio_id/stocks/:stock_id" do
    before { stub_request(:get, /www.alphavantage.co/).
              with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
              to_return(status: 200, body: response_data , headers: {})
            }

    before { get "/portfolios/#{portfolio_id}/stocks/#{stock_id}" }

    context "when position exists" do

      it "returns the position" do
        
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['ticker']).to eq('msft')
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context 'when position does not exist' do
      let(:stock_id) { Stock.last.id + 100 }

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Position/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

    end

  end
end