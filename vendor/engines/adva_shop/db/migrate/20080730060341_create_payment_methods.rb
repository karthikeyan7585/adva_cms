class CreatePaymentMethods < ActiveRecord::Migration
  def self.up
    create_table :payment_methods, :force => true do |t|
      t.string  :name
      t.references :section
    end
  end

  def self.down
    drop_table :customers
  end
end
