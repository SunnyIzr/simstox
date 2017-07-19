require 'spec_helper'

RSpec.describe "Portfolios API", type: :request do

  let!(:portfolios) { create_list(:portfolio, 3)}
  let(:portfolio_id) {Portfolio.last.id}

  describe "GET /portfolios/:id" do

    before { get "/portfolios/#{portfolio_id}" }

    context "when portfolio exists" do

      it "returns the portfolio"

      it "returns status code 200"

    end

    context 'when portfolio does not exist' do
      let(:portfolio_id) { 100 }

      it "returns not found message"

      it "returns status code 404"

    end

  end

  describe "POST /portfolios" do

    let(:valid_attributes) { {
      name: "High Yield Fixed Income",
      cash_cents: 100_000
      }}

    context "when request is valid" do
      before { post '/portfolios', params: valid_attributes }

      it "creates a portfolio"

      it "returns status code 201"

    end

    context "when request is not valid" do
      before { post '/portfolios', params: { cash_cents: 100_000 } }

      it "returns a failure message"

      it "returns status code 422" 
      
    end
  end

  describe "PUT /portfolios/:id" do

    let(:valid_attributes) { { name: "High Yield Fixed Income" } }

    context "when portfolio exists and request is valid" do
      before { put "/portfolios/#{portfolio_id}", params: valid_attributes }

      it "updates the portfolio"

      it "returns status code 201"

    end

    context "when portfolio exists and request is not valid" do
      before { put "/portfolios/#{portfolio_id}", params: { name: nil } }

      it "returns a failure message"

      it "returns status code 422"

    end

    context "when portfolio does not exist" do
      let(:portfolio_id) { 100 }
      before { put "/portfolios/#{portfolio_id}", params: valid_attributes }

      it "returns not found message"

      it "returns status code 404"
      
    end
  end

  describe "DELETE /portfolios/:id" do

    context "when portfolio exists" do
      before { delete "/portfolios/#{portfolio_id}" }

      it "destroys the portfolio"

      it "returns status code 20f"

    end

    context "when portfolio does not exist" do
      let(:portfolio_id) { 100 }
      before { delete "/portfolios/#{portfolio_id}" }

      it "returns a failure message"

      it "returns status code 422"

    end

  end

end
