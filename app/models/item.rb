class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items

  validates :name, presence: true

  def self.find_by_name(name)
    where("name LIKE ?", "%#{name}%") 
    require'pry';binding.pry
   end
end