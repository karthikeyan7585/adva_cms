class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders, :force => true do |t|
      t.references    :section
      t.string        :payment_method
      t.boolean       :shipped
      t.boolean       :paid
      t.boolean       :cancelled
      t.integer       :billing_address_id
      t.integer       :shipping_address_id
      t.datetime        :created_at
      t.datetime        :updated_at
      t.integer        :version
      
    end
  end

  def self.down
    drop_table        :orders
  end
end
