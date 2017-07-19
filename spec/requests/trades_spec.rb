require 'spec_helper'

RSpec.describe "Trades API", type: :request do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:trades) { create_list(:trade, 2)}
  let(:trade_id) { Trade.all.first.id }

  describe "GET /trades/:id" do

    before { get "/trades/#{trade_id}" }

    context "when trade exists" do

      it "returns the trade" do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(trade_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context 'when trade does not exist' do
      let(:trade_id) { 100 }

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Trade/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "POST /trades" do

    let(:valid_attributes) { {
      quantity: 10,
      ticker: "NKE", 
      price_cents: 40_00,
      portfolio_id: Portfolio.last.id
      }}

    context "when request is valid" do
      before { post '/trades', params: valid_attributes }

      it "creates a trade" do
         expect(JSON.parse(response.body)['ticker']).to eq('NKE')
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

    end

    context "when request is not valid" do
      before { post '/trades', params: { quantity: 10, ticker: "NKE", price_cents: 40_00 } }

      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Portfolio must exist/)
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      
    end
  end

end
