class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items, dependent: :destroy
  validates :name, presence: true

  def self.find_by_name(name)
    # require'pry';binding.pry
    where("name LIKE ?", "%#{name}%").limit(1).first
  end
end