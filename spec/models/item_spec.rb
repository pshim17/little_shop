describe Item, type: :model do
  describe "relationships" do
    it { belongs_to :merchants }
    it { has_many :invoice_items }
  end
end




