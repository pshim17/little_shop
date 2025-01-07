describe Merchant, type: :model do
  describe "relationships" do
    it { has_many :invoices }
    it { has_many :items }
  end 
end




