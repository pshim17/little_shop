require 'rails_helper'

describe Merchant, type: :model do
  describe "relationships" do
    it { have_many :invoices }
    it { have_many :items }
  end 
end




