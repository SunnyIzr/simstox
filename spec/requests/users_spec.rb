require 'spec_helper'

RSpec.describe "Users API", type: :request do

  let!(:user) {FactoryGirl.create(:user, first_name: "John", last_name: "Doe", username: 'johndoe')}
  let!(:portfolios) { create_list(:portfolio, 3)}
  let!(:stocks) { create_list(:stock, 2)}
  let!(:quotes) { [ 
    FactoryGirl.create(:quote, stock_id: Stock.all[0].id, price_cents: 5433), 
    FactoryGirl.create(:quote, stock_id: Stock.all[1].id, price_cents: 2791)
  ]}
  let!(:trades) { create_list(:trade, 2)}
  let(:user_id) { User.last.id }

  describe "GET /users/:id" do

    before do
      token = JsonWebToken.encode({user_id: user.id})

      get "/users/#{user_id}", headers: {Authorization: token}
    end

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

    context 'when request is unauthorized' do
      before do
        id = user.id + 100
        token = JsonWebToken.encode({user_id: id})
      
         get "/users/#{user_id}", headers: {Authorization: token}
      end

      it 'returns permission denied message' do
        expect(response.body).to match(/Permission denied/)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(401)
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

  describe "POST /users" do

    let(:valid_attributes) { {
      username: "johndoe123",
      first_name: "John",
      last_name: "Doe",
      password: 'password'
      }}

    context "when request is valid" do
      before { post '/users', params: valid_attributes }

      it "creates a user" do
        expect(JSON.parse(response.body)['username']).to eq('johndoe123')
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

    end

    context "when request is not valid" do
      before { post '/users', params: { username: 'johndoe', first_name: 'John', password: 'password' } }

      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Last name can't be blank/)
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      
    end
  end

  describe "POST /users/login" do

    let(:valid_attributes) { {
      username: "johndoe",
      password: 'password'
      }}

    context "when login credentials are valid" do
      before { post '/users/login', params: valid_attributes }

      it "returns a user" do
        expect(JSON.parse(response.body)['user']['username']).to eq('johndoe')
      end

      it 'returns an auth token' do
        expect(JsonWebToken.decode(JSON.parse(response.body)['auth_token'])['user_id']).to eq(user.id)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(200)
      end

    end

    context "when username is not found" do
      before { post '/users/login', params: { username: 'johndoe123', password: 'password' } }

      it "returns a failure message" do
        expect(response.body).to match(/Invalid credentials/)
      end

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end
      
    end

    context "when password is not correct" do
      before { post '/users/login', params: { username: 'johndoe', password: 'password123' } }

      it "returns a failure message" do
        expect(response.body).to match(/Invalid credentials/)
      end

      it "returns status code 401" do
        expect(response).to have_http_status(401)
      end
      
    end
  end

end
