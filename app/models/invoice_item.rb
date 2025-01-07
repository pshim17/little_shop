class Invoice_item < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
end