class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :status
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
