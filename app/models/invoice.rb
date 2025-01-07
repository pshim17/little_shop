class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchants
  has_many :invoice_items
end