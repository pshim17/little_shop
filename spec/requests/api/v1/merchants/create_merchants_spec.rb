require 'rails_helper'

RSpec.describe "Create a Merchant", type: :request do
  it "can create a new merchant" do
    merchant_name = {name: "Amazon"}

    post "/api/v1/merchants",params: merchant_name 

    expect(response).to be_successful
    expect(response.status).to eq(201)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Amazon')
  end
  it "returns an error if the name is missing" do
    invalid_params = { name: "" }

    post "/api/v1/merchants", params: invalid_params

    expect(response).not_to be_successful
    expect(response.status).to eq(422)
    error = JSON.parse(response.body, symbolize_names: true)
    expect(error[:error]).to eq("unprocessable entity")
  end
end