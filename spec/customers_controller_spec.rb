require 'rails_helper'

describe "Little Shop API", type: :request do    

  it "shows customers" do
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

    invoice1 = Invoice.create!(customer_id: customer1.id, merchant_id: test_merchant1.id, status: "shipped")
    invoice2 = Invoice.create!(customer_id: customer1.id, merchant_id: test_merchant1.id, status: "shipped")

    
    # Create an initial item to test updates
    test_item_1 = Item.create!(
    name: "Old Item Name",
    description: "Old description of the item.",
    unit_price: 50.00,
    merchant_id: test_merchant.id
  )
  
    get "/api/v1/customers", params: 

    # Reload the item to reflect updated changes
    test_item_1.reload

    # Expect the response to return the correct updated attributes
    expect(response).to be_successful
    expect(test_item_1.name).to eq(updated_attributes[:name])
    expect(test_item_1.description).to eq(updated_attributes[:description])
    expect(test_item_1.unit_price).to eq(updated_attributes[:unit_price])
  end
end