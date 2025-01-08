class Merchant < ApplicationRecord
  has_many :invoices
  validates :name, presence: true
  has_many :items, dependent: :destroy
end