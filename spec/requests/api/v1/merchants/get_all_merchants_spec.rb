require 'rails_helper'

RSpec.describe "Get all Merchants", type: :request do
  it "can get all merchants" do
    Merchant.create!(name: "Merchant1")
    Merchant.create!(name: "Merchant2")
    
    get "/api/v1/merchants"
    expect(response.status).to eq(200)

    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(2)

    results.each do |result|
      expect(result).to have_key(:id)
      expect(result[:id]).to be_a(String)

      expect(result).to have_key(:type)
      expect(result[:type]).to be_a(String)

      expect(result).to have_key(:attributes)
      expect(result[:attributes]).to have_key(:name)
      expect(result[:attributes][:name]).to be_a(String)
    end
  end

  it "get all merchants sorted by newest to oldest" do
    oldest_merchant = Merchant.create!(name: "Merchant1")
    newest_merchant = Merchant.create!(name: "Merchant2")

    get "/api/v1/merchants", params: { sorted: "age" }
    expect(response.status).to eq(200)

    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(2)

    expect(results.first[:id].to_i).to eq(newest_merchant.id)
    expect(results.last[:id].to_i).to eq(oldest_merchant.id)
  end

  it "get all merchants with returned items (check invoice)" do
   merchant1 = Merchant.create!(name: "Merchant1")
   merchant2 = Merchant.create!(name: "Merchant2")

   customer = Customer.create!(first_name: "Rubeus", last_name: "Hagrid")

   Invoice.create!(status: "returned", merchant: merchant1, customer: customer)
   Invoice.create!(status: "shipped", merchant: merchant2, customer: customer)

   get "/api/v1/merchants", params: { status: "returned" }
   expect(response.status).to eq(200)

   results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(results.count).to eq(1)

    expect(results.first).to have_key(:id)
    expect(results.first[:id].to_i).to eq(merchant1.id)
  end

  it "get all merchants with calculated count of items" do
   merchant1 = Merchant.create!(name: "Merchant1")
   merchant2 = Merchant.create!(name: "Merchant2")
    
   Item.create!(name: "Item1", merchant: merchant1)
   Item.create!(name: "Item2", merchant: merchant2)
   
   get "/api/v1/merchants", params: { count: "true" }
   expect(response.status).to eq(200)

   results = JSON.parse(response.body, symbolize_names: true)[:data]
   
   expect(results.count).to eq(2)

    results.each do |result|
      merchant_id = result[:id].to_i
      if merchant_id == merchant1.id
        expect(result[:attributes][:name]).to eq(merchant1.name)
        expect(result[:attributes][:item_count].to_i).to be_a(Integer)
      elsif merchant_id == merchant2.id
        expect(result[:attributes][:name]).to eq(merchant2.name)
        expect(result[:attributes][:item_count].to_i).to be_a(Integer)
      end
    end
  end
end