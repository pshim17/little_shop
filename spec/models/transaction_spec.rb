require 'rails_helper'

describe Transaction, type: :model do
  describe "relationships" do
    it { belong_to :invoice }
  end
end




