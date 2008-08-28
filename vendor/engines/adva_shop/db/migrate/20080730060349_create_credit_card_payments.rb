class CreateCreditCardPayments < ActiveRecord::Migration
  def self.up
    create_table :credit_card_payments, :force => true do |t|
      t.string  :payment_gateway
      t.string :account_email
      t.string :accepted_cards        
      t.references :section
    end
  end

  def self.down
    drop_table :customers
  end
end
