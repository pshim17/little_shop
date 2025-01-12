require 'rails_helper'

describe "Little Shop API", type: :request do    

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
  
    get "/api/v1/customers/merchant/#{test_merchant1.id}" 

    expect(response).to be_successful
    expect(response).to be_an(Array)

    customers = JSON.parse(response.body, symbolize_names: true)

    expect(customers.size).to eq(3)

    expect(customers[:data][0][:attributes][:first_name]).to eq(customer1.first_name)
    expect(customers[:data][0][:attributes][:last_name]).to eq(customer1.last_name)

    customers.each do |customer|
      expect(customer).to have_key(first_name)
      expect(customer[:first_name].to be_a(String)

      expect(customer).to have_key("last_name")
      expect(customer["last_name"]).to be_a(String)
    end
    
  end
end