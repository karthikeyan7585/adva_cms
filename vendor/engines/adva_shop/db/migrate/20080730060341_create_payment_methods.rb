class CreatePaymentMethods < ActiveRecord::Migration
  def self.up
    create_table :payment_methods, :force => true do |t|
      t.references  :section
      t.string      :payment_type
      t.text        :payment_attributes
    end
  end

  def self.down
    drop_table :customers
  end
end
