class AddCustomerToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :customer, null: false, foreign_key: true
  end
end
