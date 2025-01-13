class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items, dependent: :destroy
  validates :name, presence: true

  def self.find_by_name(name)
    where("LOWER(name) LIKE ?", "%#{name.downcase}%").limit(1).first
  end

  def self.sort_by_age
    order(created_at: :desc)
  end

  def self.returned_invoices
    joins(:invoices).where(invoices: {status: "returned"}).distinct
  end

  def self.add_item_count
    left_joins(:items).select("merchants.*, COUNT(items.id) AS item_count").group("merchants.id").order(id: :asc)
  end
end