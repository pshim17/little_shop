require 'rails_helper'

describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many :invoice_items }
    it {belong_to :customer}
    it {belong_to :merchant}
  end
end




