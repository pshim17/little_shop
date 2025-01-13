require 'rails_helper'

RSpec.describe "Get one Merchant", type: :request do
  it "can get one merchant by id" do
    merchant1 = Merchant.create!(id: 42, name: "Merchant1")
    
    id = merchant1.id

    get "/api/v1/merchants/#{id}"
    expect(response.status).to eq(200)

    merchantById = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchantById).to have_key(:id)
    expect(merchantById[:id]).to be_a(String)

    expect(merchantById).to have_key(:type)
    expect(merchantById[:type]).to be_a(String)

    expect(merchantById).to have_key(:attributes)
    expect(merchantById[:attributes]).to have_key(:name)
    expect(merchantById[:attributes][:name]).to be_a(String)
  end
end