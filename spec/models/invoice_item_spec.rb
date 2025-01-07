describe Invoice_item, type: :model do
  describe "relationships" do
    it { should belongs_to :invoice }
    it { should belongs_to :item}
  end
end




