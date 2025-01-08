require 'rails_helper'

RSpec.describe "Create a Merchant", type: :request do
  it "can create a new merchant" do
    details = {name: "Amazon"}

    post "/api/v1/merchants",params: details 

    expect(response).to be_successful
    expect(response.status).to eq(201)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Amazon')
  end
end