require 'rails_helper'

RSpec.describe "Update a Merchant", type: :request do
  it "can update a merchant" do
    merchant      = Merchant.create!(name: "Nike")
    merchant_name = {name: "Amazon"}
    
    patch "/api/v1/merchants/#{merchant.id}",params: merchant_name 

    expect(response).to be_successful
    expect(response.status).to eq(200)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Amazon')
  end

  describe "Sad Paths" do
    it "can fails if merchant does not exist" do
      patch "/api/v1/merchants/8000"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("Couldn't find Merchant with 'id'=8000")
    end

    it "fails if no params passed" do
      merchant = Merchant.create!(name: "Nike")
              
      patch "/api/v1/merchants/#{merchant.id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      error = JSON.parse(response.body, symbolize_names: true)[:error]
      expect(error).to eq("unprocessable entity")
    end
  end
end