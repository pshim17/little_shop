require 'rails_helper'

RSpec.describe "Delete a Merchant", type: :request do
  it "deletes a merchant" do
    merchant1 = Merchant.create!(name: "WallWorld")
    merchant2 = Merchant.create!(name: "Costco")
    merchant3 = Merchant.create!(name: "Target")
    merchant4 = Merchant.create!(name: "Best Buy")
    merchant5 = Merchant.create!(name: "Amazon")

    delete "/api/v1/merchants/#{merchant3.id}"

    expect(response).to be_successful
    expect(Merchant.all).to_not include(merchant3.id)
  end
end