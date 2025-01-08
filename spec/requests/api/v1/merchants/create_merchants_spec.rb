require 'rails_helper'

RSpec.describe "Create a Merchant" do
  it "can create a new merchant" do
    details = {name: "Amazon"}

    post "api/v1/merchants",params: details 

    expect(response).to be_successful
    expect(response.status).to eq(201)
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    require 'pry'; binding.pry
    expect(merchant.name).to eq('Amazon')
  end
end