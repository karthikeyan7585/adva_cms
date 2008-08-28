class CreateBankPayments < ActiveRecord::Migration
  def self.up
    create_table :bank_payments, :force => true do |t|
      t.string  :bank_name
      t.integer :account_number
      t.string  :payee_name
      t.binary  :other_details
      t.float   :shipping_cost
      t.references :section
    end
  end

  def self.down
    drop_table :customers
  end
end
