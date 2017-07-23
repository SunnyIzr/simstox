require 'spec_helper'

RSpec.describe "Trades API", type: :request do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:stocks) { create_list(:stock, 2)}
  let!(:trades) { create_list(:trade, 2)}
  let(:trade_id) { Trade.all.first.id }

  describe "GET /trades/:id" do

    before do
      token = JsonWebToken.encode({user_id: user.id})

      get "/trades/#{trade_id}", headers: {Authorization: token}
    end

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
      let(:trade_id) { Trade.last.id + 100 }

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Trade/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end

    context 'when request is unauthorized' do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
         get "/trades/#{trade_id}", headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(401)
      end

    end

  end

  describe "POST /trades" do

    let(:valid_attributes) { {
      quantity: 10,
      stock_id: Stock.last.id, 
      price_cents: 40_00,
      portfolio_id: Portfolio.last.id
      }}

    context "when request is valid" do
      before do
        token = JsonWebToken.encode({user_id: user.id})

        post '/trades', params: valid_attributes, headers: {Authorization: token}
      end

      it "creates a trade" do
         expect(JSON.parse(response.body)['price_cents']).to eq(4000)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

    end

    context "when request is not valid" do
      before do
        token = JsonWebToken.encode({user_id: user.id})

        post '/trades', params: { quantity: 10, portfolio_id: Portfolio.last.id, price_cents: 40_00 }, headers: {Authorization: token}
      end

      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Stock must exist/)
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      
    end

    context 'when request is unauthorized' do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
         post '/trades', params: valid_attributes, headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(401)
      end

    end
    
  end

end
