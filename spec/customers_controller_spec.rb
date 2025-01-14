require 'rails_helper'

describe "Little Shop API", type: :request do  
  describe "happy paths" do

    it "shows customer names by merchant" do
    
      test_merchant1 = Merchant.create!(name: "Test Merchant1")
      test_merchant2 = Merchant.create!(name: "Test Merchant2")

      customer1 = Customer.create!( {
        "first_name": "Parker",
        "last_name": "Daugherty"
      })
      customer2 = Customer.create!( {
        "first_name": "Kirstin",
        "last_name": "Wehner"
      })
      customer3 = Customer.create!( {
        "first_name": "Albina",
        "last_name": "Erdman"
      })
      customer4 = Customer.create!( {
        "first_name": "Karol",
        "last_name": "Eloiwan"
      })

      invoice1 = Invoice.create!(customer_id: customer1.id, merchant_id: test_merchant1.id, status: "shipped")
      invoice2 = Invoice.create!(customer_id: customer2.id, merchant_id: test_merchant1.id, status: "shipped")
      invoice3 = Invoice.create!(customer_id: customer3.id, merchant_id: test_merchant1.id, status: "shipped")
      invoice4 = Invoice.create!(customer_id: customer4.id, merchant_id: test_merchant2.id, status: "shipped")
    
      get "/api/v1/merchants/#{test_merchant1.id}/customers" 
      # puts response.status
      # puts response.body

      expect(response).to be_successful
      

      customers = JSON.parse(response.body, symbolize_names: true)

      expect(customers[:data]).to be_an(Array)
      expect(customers[:data].size).to eq(3)

      expect(customers[:data][0][:attributes][:first_name]).to eq(customer1.first_name)
      expect(customers[:data][0][:attributes][:last_name]).to eq(customer1.last_name)
      expect(customers[:data][0][:attributes][:first_name]).to eq("Parker")
      expect(customers[:data][1][:attributes][:first_name]).to eq("Kirstin")
      expect(customers[:data][2][:attributes][:first_name]).to eq("Albina")

      customers[:data].each do |customer|
        expect(customer[:attributes]).to be_a(Hash)
        expect(customer[:attributes]).to have_key(:first_name)
        expect(customer[:attributes][:first_name]).to be_a(String)

        expect(customer[:attributes]).to have_key(:last_name)
        expect(customer[:attributes][:last_name]).to be_a(String)
      end
      
    end
  end

  describe "edge cases" do
    it "will gracefully handle if a Merchant id doesn't exist" do
      test_merchant1 = Merchant.create!(name: "Test Merchant1")

      customer1 = Customer.create!( {
        "first_name": "Parker",
        "last_name": "Daugherty"
      })

      invoice1 = Invoice.create!(customer_id: customer1.id, merchant_id: test_merchant1.id, status: "shipped")

      get "/api/v1/merchants/509484320583094583049582904852048/customers" 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      customers = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(customers[:error]).to eq("Merchant ID# 509484320583094583049582904852048 not found.")
    end

  end
end