class CreateExternalPayments < ActiveRecord::Migration
  def self.up
    create_table :external_payments, :force => true do |t|
      t.string  :payment_gateway
      t.string :account_email
      t.references :section
    end
  end

  def self.down
    drop_table :customers
  end
end
