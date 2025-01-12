require 'rails_helper'

RSpec.describe "Find Merchant", type: :request do
  it "can find one merchant based on search criteria" do
    merchant1 = Merchant.create!(name: "Adidas")
    merchant2 = Merchant.create!(name: "Nike")
    merchant3 = Merchant.create!(name: "hadid")

    merchant_name = {name: "DiD"}

    get "/api/v1/merchants/find", params: merchant_name 

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:attributes][:name]).to eq('Adidas') 

    invalid_merchant_name = { name: "123" }

    get "/api/v1/merchants/find", params: invalid_merchant_name 

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchant[:data]).to eq(nil) 
  end
end