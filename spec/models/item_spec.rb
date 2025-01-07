require 'rails_helper'

describe Item, type: :model do
  describe "relationships" do
    it { belong_to :merchants }
    it { have_many :invoice_items }
  end
end




