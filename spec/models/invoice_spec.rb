describe Invoice_spec, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it {belongs_to :customer}
    it {belongs_to :merchants}
  end
end




