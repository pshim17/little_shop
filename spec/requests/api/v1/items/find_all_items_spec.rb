require 'rails_helper'

RSpec.describe "Find Items", type: :request do
  it "can find all items based on search criteria" do
    test_merchant = Merchant.create!(name: "Test Merchant")

    item1 = Item.create!(name: "Laser Thermometer", description: "Instant temperature readings", unit_price: 150.45, merchant: test_merchant)
    item2 = Item.create!(name: "Digital Scale", description: "Precise weight measurements", unit_price: 58.99, merchant: test_merchant)
    item3 = Item.create!(name: "Baking Sheet", description: "Perfect for pastries", unit_price: 25.60, merchant: test_merchant)
    item4 = Item.create!(name: "Cooking Spoon", description: "Stirring made easy", unit_price: 14.30, merchant: test_merchant)
    item_name = { name: "did" }

    get "/api/v1/items/find_all", params: item_name 

    expect(response).to be_successful
    expect(response.status).to eq(200)

    item = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items[:attributes][:name]).to eq('Adidas')
  end
end