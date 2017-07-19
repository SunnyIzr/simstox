require 'spec_helper'

RSpec.describe "Trades API", type: :request do

  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:trades) { create_list(:trade, 2)}
  let(:trade_id) { Trade.all.first.id }

  describe "GET #show" do

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

  describe "POST #create" do

    let(:valid_attributes) { {
      quantity: [*10..5_000].sample,
      ticker: %w[T CSCO KO CMCSA INTC NKE ORCL PFE TD VZ WFC].sample, 
      price_cents: [*30_00..60_00].sample,
      portfolio_id: Portfolio.all.sample.id
      }}

    context "when request is valid" do

      it "creates a trade"

      it "returns status code 201"

    end

    context "when request is not valid" do

      it "returns a failure message"

      it "returns status code 422"
      
    end
  end

end
