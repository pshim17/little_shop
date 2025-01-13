require 'rails_helper'

RSpec.describe 'Get all items for a merchant', type: :request do
  it 'can get all items for merchant id' do

    amazon = Merchant.create!(name: 'Amazon')
    brush  = Item.create!(name: 'Brush', description: 'Big Brush', unit_price: 5.20, merchant_id: amazon.id)
    comb   = Item.create!(name: 'Comb', description: 'Little Comb', unit_price: 6.75, merchant_id: amazon.id)
    
    get "/api/v1/merchants/#{amazon.id}/items"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    items.each do |item| 
      expect(item[:type]).to eq('item')

      attrs = item[:attributes]
      
      expect(attrs[:name]).to be_a(String)
      expect(attrs[:description]).to be_a(String)
      expect(attrs[:unit_price]).to be_a(Float)
      expect(attrs[:merchant_id]).to eq(amazon.id)
    end
  end
  
  it "returns an empty array if the merchant has no items" do
    merchant = Merchant.create!(name: "Nike")
  
    get "/api/v1/merchants/#{merchant.id}/items"
  
    expect(response).to be_successful
    expect(response.status).to eq(200)
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items).to eq([])
  end
end