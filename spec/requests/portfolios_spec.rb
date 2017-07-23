require 'spec_helper'

RSpec.describe "Portfolios API", type: :request do

  let!(:user) {FactoryGirl.create(:user)}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let(:portfolio_id) {Portfolio.last.id}

  describe "GET /portfolios/:id" do
  
    context "when portfolio exists" do
      before do
        token = JsonWebToken.encode({user_id: user.id})
      
        get "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it "returns the portfolio" do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(portfolio_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context 'when portfolio does not exist' do
      before do
        portfolio_id = Portfolio.last.id + 100
        token = JsonWebToken.encode({user_id: user.id})
      
        get "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Portfolio/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

    end

    context 'when request is unauthorized' do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
        get "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(401)
      end

    end

  end

  describe "POST /portfolios" do

    let(:valid_attributes) { {
      name: "High Yield Fixed Income",
      cash_cents: 100_000,
      user_id: user.id
      }}

    context "when request is valid" do
      before do 
        token = JsonWebToken.encode({user_id: user.id})
        post '/portfolios', params: valid_attributes, headers: {Authorization: token}
      end

      it "creates a portfolio" do
         expect(JSON.parse(response.body)['name']).to eq('High Yield Fixed Income')
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

    end

    context "when request is not valid" do
      before do 
        token = JsonWebToken.encode({user_id: user.id})
        post '/portfolios', params: { cash_cents: 100_000, user_id: user.id }, headers: {Authorization: token}
      end

      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      
    end

    context "when request is unauthorized" do
      before do 
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
        post '/portfolios', params: valid_attributes, headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end
      
    end
  end

  describe "PUT /portfolios/:id" do

    let(:valid_attributes) { { name: "Blue Chip Value" } }

    context "when portfolio exists and request is valid" do
      before do
        token = JsonWebToken.encode({user_id: user.id})
      
        put "/portfolios/#{portfolio_id}", params: valid_attributes, headers: {Authorization: token}
      end

      it "updates the portfolio" do
        expect(JSON.parse(response.body)['name']).to eq('Blue Chip Value')
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context "when portfolio does not exist" do
      before do
        token = JsonWebToken.encode({user_id: user.id})
        portfolio_id = Portfolio.last.id + 100
      
        put "/portfolios/#{portfolio_id}", params: valid_attributes, headers: {Authorization: token}
      end

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Portfolio/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
      
    end

    context "when request is unauthorized" do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
        put "/portfolios/#{portfolio_id}", params: valid_attributes, headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end

    end
  end

  describe "DELETE /portfolios/:id" do

    context "when portfolio exists" do
      before do
        token = JsonWebToken.encode({user_id: user.id})
      
        delete "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it "destroys the portfolio" do
        expect(Portfolio.all.size).to eq(2)
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end

    end

    context "when portfolio does not exist" do
      before do
        token = JsonWebToken.encode({user_id: user.id})
        portfolio_id = Portfolio.last.id + 100
      
        delete "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it "returns not found message" do
        expect(response.body).to match(/Couldn't find Portfolio/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

    end

    context "when request is unauthorized" do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
        delete "/portfolios/#{portfolio_id}", headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end

    end

  end

end
