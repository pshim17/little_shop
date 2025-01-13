require 'rails_helper'

RSpec.describe "Find Items", type: :request do
  before(:each) do
    @test_merchant = Merchant.create!(name: "Test Merchant")

    @item1 = Item.create!(name: "Laser Thermometer", description: "Instant temperature readings", unit_price: 150.45, merchant: @test_merchant)
    @item2 = Item.create!(name: "Digital Scale", description: "Precise weight measurements", unit_price: 58.99, merchant: @test_merchant)
    @item3 = Item.create!(name: "Baking Sheet", description: "Perfect for pastries", unit_price: 25.60, merchant: @test_merchant)
    @item4 = Item.create!(name: "Cooking Spoon", description: "Stirring made easy", unit_price: 14.30, merchant: @test_merchant)
    @item5 = Item.create!(name: "Booking Soon", description: "Steerring made easy", unit_price: 14.30, merchant: @test_merchant)

  end

  it "can find all items searched by name" do
    item_name = { name: "oo" }

    get "/api/v1/items/find_all", params: item_name
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(2)
    expect(items).to be_a(Hash)

    expect(items[:data][0][:attributes][:name]).to eq(@item4.name)
    expect(items[:data][1][:attributes][:name]).to eq(@item5.name)
  end

  it "can find all items searched by min_price" do
    item_min_price = { min_price: 50 }
    get "/api/v1/items/find_all", params: item_min_price
    
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(2)

    item_min_price = { min_price: 1000 }
    get "/api/v1/items/find_all", params: item_min_price
    
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(0)
  end

  it "can find all items searched by min_price" do
    item_max_price = { min_price: 25.60 }
    get "/api/v1/items/find_all", params: item_max_price
    
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(3)

    item_max_price = { max_price: 12 }
    get "/api/v1/items/find_all", params: item_max_price
    
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:data].count).to eq(0)
  end

  it "returns an error when name and min_price or max_price are sent together" do
    item_name_min_price = { name: "Thermo", min_price: 50 }
    get "/api/v1/items/find_all", params: item_name_min_price
    
    expect(response.status).to eq(400)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:errors]).to eq("Cannot send both name and min_price or max_price parameters")

    item_name_max_price = { name: "Thermo", max_price: 50 }
    get "/api/v1/items/find_all", params: item_name_min_price
    
    expect(response.status).to eq(400)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:errors]).to eq("Cannot send both name and min_price or max_price parameters")
  end

  it "returns an error when min_price/max_price is less than 0" do
    invalid_min_price = { min_price: -5 }
    get "/api/v1/items/find_all", params: invalid_min_price
    
    expect(response.status).to eq(400)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:errors]).to eq("min_price/max_price cannot be less than 0")
    
    invalid_max_price = { max_price: -10 }
    get "/api/v1/items/find_all", params: invalid_max_price
    
    expect(response.status).to eq(400)

    items = JSON.parse(response.body, symbolize_names: true)
    
    expect(items[:errors]).to eq("min_price/max_price cannot be less than 0")
  end
end
