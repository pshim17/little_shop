require 'rails_helper'

RSpec.describe "Find Items", type: :request do
  before(:each) do
    @test_merchant = Merchant.create!(name: "Test Merchant")

    @item1 = Item.create!(name: "Laser Thermometer", description: "Instant temperature readings", unit_price: 150.45, merchant: @test_merchant)
    @item2 = Item.create!(name: "Digital Scale", description: "Precise weight measurements", unit_price: 58.99, merchant: @test_merchant)
    @item3 = Item.create!(name: "Baking Sheet", description: "Perfect for pastries", unit_price: 25.60, merchant: @test_merchant)
    @item4 = Item.create!(name: "Cooking Spoon", description: "Stirring made easy", unit_price: 14.30, merchant: @test_merchant)
  end

  it "can find all items searched by name" do
    item_name = { name: "Scale" }

    get "/api/v1/items/find_all", params: item_name

    expect(response.status).to eq(200)

    # require'pry';binding.pry
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    items.each do |item|
      expect(item[:attributes][:name]).to include(item_name[:name])
    end
  end

  # it "can find all items searched by price" do
  #   item_price = { unit_price: 50 }

  #   get "/api/v1/items/find_all", params: item_price

  #   expect(response.status).to eq(200)

  #   items = JSON.parse(response.body, symbolize_names: true)[:data]
  # end
end
