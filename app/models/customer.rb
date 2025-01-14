class Customer < ApplicationRecord
  has_many :invoices

  def self.customers_by_merchant(merchant_id)
    joins(:invoices).where(invoices: {merchant_id: merchant_id}).distinct
  end
end