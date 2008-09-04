class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders, :force => true do |t|
      t.references    :section
      t.string        :payment_method
      t.integer       :status
      t.references    :billing_address
      t.references    :shipping_address
      t.datetime      :created_at
      t.datetime      :updated_at
      t.integer       :version
    end
  end

  def self.down
    drop_table        :orders
  end
end
