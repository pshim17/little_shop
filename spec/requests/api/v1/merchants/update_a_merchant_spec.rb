require 'rails_helper'

RSpec.describe "Update a Merchant", type: :request do
  it "can update a merchant" do
    merchant_name = {name: "Amazon"}

    patch "/api/v1/merchants",params: merchant_name 

    expect(response).to be_successful
    expect(response.status).to eq(201)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Amazon')
  end
end