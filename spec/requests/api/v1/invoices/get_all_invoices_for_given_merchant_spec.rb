require 'rails_helper'

RSpec.describe "Find Invoices", type: :request do
  before(:each) do
    @test_merchant_1 = Merchant.create!(name: "Test Merchant 1")
    @test_merchant_2 = Merchant.create!(name: "Test Merchant 2")
    @test_customer = Customer.create!(first_name: 'Buddy', last_name: "De Elf")

    @test_invoice1 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "shipped")
    @test_invoice2 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "packaged")
    @test_invoice3 = Invoice.create!(customer_id: @test_customer.id, merchant_id: @test_merchant_1.id, status: "returned")
  end

  it 'can get all invoices' do
    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices"
    expect(response.status).to eq(200)
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(invoices.length).to eq(3)

    get "/api/v1/merchants/#{@test_merchant_2.id}/invoices"
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response.status).to eq(200)
    expect(invoices.length).to eq(0)
  end

  it 'can return all invoices for given status' do
    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=shipped"
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    expect(invoices[:data].length).to eq(1)

    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=packaged"
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    expect(invoices[:data].length).to eq(1)

    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=returned"
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    expect(invoices[:data].length).to eq(1)
  end

  it "can return 404 error when the invalid merchant number is passed in" do
    get "/api/v1/merchants/9999/invoices" 
    expect(response).to have_http_status(404)
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:error]).to eq("Merchant not found")
    expect(merchants[:message]).to eq("Couldn't find Merchant with 'id'=9999")  

    get "/api/v1/merchants/hello/invoices" 
    expect(response).to have_http_status(404)
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:error]).to eq("Merchant not found")
    expect(merchants[:message]).to eq("Couldn't find Merchant with 'id'=hello")  
  end

  it "can handle when invalid status is passed in" do
    get "/api/v1/merchants/#{@test_merchant_1.id}/invoices?status=nostatus"
    expect(response.status).to eq(200)

    invoices = JSON.parse(response.body, symbolize_names: true)
    expect(invoices[:data].length).to eq(0)
  end
end
