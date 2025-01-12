class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true

  def self.find_by_name(name)
    where("name ILIKE ? ", "%#{name}%")
  end

  def self.find_by_price(price, type)
    if type == :min_price
      where("unit_price >= ?", "#{price}")
    elsif type == :max_price
      where("unit_price <= ?", "#{price}")
    end
  end
end
