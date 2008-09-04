class CreateOrderVersions < ActiveRecord::Migration
  def self.up
    create_table :order_versions, :force => true do |t|
      t.references    :section
      t.references    :order
      t.integer       :version
      t.string        :payment_method
      t.integer       :status
      t.references    :billing_address
      t.references    :shipping_address
      t.datetime      :created_at
      t.datetime      :updated_at
      
    end
  end

  def self.down
    drop_table :order_versions
  end
end
