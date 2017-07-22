require 'spec_helper'

RSpec.describe "Users API", type: :request do

  let!(:user) {FactoryGirl.create(:user, first_name: "John", last_name: "Doe")}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:stocks) { create_list(:stock, 2)}
  let!(:quotes) { [ 
    FactoryGirl.create(:quote, stock_id: Stock.all[0].id, price_cents: 5433), 
    FactoryGirl.create(:quote, stock_id: Stock.all[1].id, price_cents: 2791)
  ]}
  let!(:trades) { create_list(:trade, 2)}
  let(:user_id) { User.last.id }

  describe "GET /users/:id" do

    before { get "/users/#{user_id}" }

    context "when user exists" do

      it "returns the user" do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['first_name']).to eq("John")
        expect(JSON.parse(response.body)['last_name']).to eq("Doe")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context 'when user does not exist' do
      let(:user_id) { User.last.id + 100 }

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find User/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end

  end

  describe "GET /users" do

    before { get "/users" }

    it "returns users" do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body)[0]['first_name']).to eq("John")
      expect(JSON.parse(response.body)[0]['last_name']).to eq("Doe")
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

  end

end