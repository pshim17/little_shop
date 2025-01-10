class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true

  def self.find_by_name(name)
    where("name ILIKE ? ", "%#{name}%")
  end

  # def self.find_by_price(price)
  #   where("unit_price >= ? AND unit_price <= ?")
  # end
end
