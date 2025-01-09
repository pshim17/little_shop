require 'rails_helper'

RSpec.describe "items", type: :request do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Test Merchant")
    @item1 = Item.create!(name: "Laser Thermometer", description: "Instant temperature readings", unit_price: 150.45, merchant: @merchant1)
    @item2 = Item.create!(name: "Digital Scale", description: "Precise weight measurements", unit_price: 58.99, merchant: @merchant1)

    @merchant2 = Merchant.create!(name: "Test Merchant")
    @item3 = Item.create!(name: "Baking Sheet", description: "Perfect for pastries", unit_price: 25.60, merchant: @merchant2)
    @item4 = Item.create!(name: "Cooking Spoon", description: "Stirring made easy", unit_price: 14.30, merchant: @merchant2)
  end

  it "can get all items" do 
    get "/api/v1/items"
    expect(response.status).to eq(200)

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(4)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      attributes = item[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end
  end

  it "can handle errors when no items are found" do 
    Item.destroy_all

    get "/api/v1/items"
    expect(response.status).to eq(422)

    json_response = JSON.parse(response.body)

    expect(json_response['message']).to eq("Your query could not be completed")
    expect(json_response['errors']).to include("No items found")
  end

  it "can get all items by price in ascending order (low to high)" do 
    get "/api/v1/items?sorted=price" 
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    prices = items.map { |item| item[:attributes][:unit_price] }
    expect(prices).to eq(prices.sort)
  end

  it "can get an item by id" do 
    id = @item1.id
    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(200)

    expect(item).to have_key(:data)
 
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a(String)

    expect(item[:data]).to have_key(:attributes)
    attributes = item[:data][:attributes]
    
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(Float)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_a(Integer)
  end

  it "can handle an error: a 404 error when trying to get an id that does not exist" do    
    get "/api/v1/items/100" 
    expect(response.status).to eq(404)

    error_response = JSON.parse(response.body, symbolize_names: true)
    json_response = JSON.parse(response.body)

    expect(error_response[:message]).to eq("Your query could not be completed")
    expect(json_response['errors']).to include("Item not found")

    get "/api/v1/items/item1" 
    expect(response.status).to eq(404)

    expect(error_response[:message]).to eq("Your query could not be completed")
    expect(json_response['errors']).to include("Item not found")
  end

  it "can create a new item" do 
    attributes = {
      name: "Vanilla Ice Cream",
      description: "smooth and refreshing",
      unit_price: 4.49,
      merchant_id: @merchant1.id
    }

    attributes = {
      name: "Vanilla Ice Cream",
      description: "smooth and refreshing",
      unit_price: 4.49,
      merchant_id: @merchant2.id
    }

    post "/api/v1/items", params: {item: attributes}

    item_new = JSON.parse(response.body, symbolize_names: true)

    get "/api/v1/items"
    expect(response).to have_http_status(200)
    
    expect(item_new[:data][:attributes][:name]).to eq("Vanilla Ice Cream")
  end

  it "can handle errors for when creating an invalid item" do
    invalid_attributes = {
      name: "",
      description: "A valid description",
      unit_price: 25.50,
      merchant_id: @merchant1.id
    }

    post "/api/v1/items", params: { item: invalid_attributes }
    expect(response.status).to eq(422)

    json_response = JSON.parse(response.body)

    expect(json_response['message']).to eq("Your query could not be completed")
    expect(json_response['errors']).to include("Name can't be blank")
  end

  it "can delete items" do
    items = Item.all
    expect(items.count).to eq(4)
    
    delete "/api/v1/items/#{@item1.id}"
    delete "/api/v1/items/#{@item2.id}"

    expect(response).to be_successful 
    expect(response.status).to eq(204)

    expect(items.count).to eq(2)
  end

  it "can handle error and return  404 error when trying to delete an item that does not exist" do
    delete "/api/v1/items/123" 
  
    json_response = JSON.parse(response.body)

    expect(response.status).to eq(404)
    expect(json_response['message']).to eq("Your query could not be completed")
    expect(json_response['errors']).to include("Item not found")
  end
end