require 'spec_helper'

RSpec.describe "Positions API", type: :request do

  # describe "GET /portfolios/:portfolio_id/stocks/:stock_id" do

  #   before { get "/portfolios/#{portfolio_id}" }

  #   context "when portfolio exists" do

  #     it "returns the portfolio" do
  #       expect(JSON.parse(response.body)).not_to be_empty
  #       expect(JSON.parse(response.body)['id']).to eq(portfolio_id)
  #     end

  #     it "returns status code 200" do
  #       expect(response).to have_http_status(200)
  #     end

  #   end

  #   context 'when portfolio does not exist' do
  #     let(:portfolio_id) { Portfolio.last.id + 100 }

  #     it "returns not found message" do
  #       expect(response.body).to match(/Couldn't find Portfolio/)
  #     end

  #     it "returns status code 404" do
  #       expect(response).to have_http_status(404)
  #     end

  #   end

  # end
end