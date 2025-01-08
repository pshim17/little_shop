class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items, dependent: :destroy
end