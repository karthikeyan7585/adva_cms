class CreateOrderVersions < ActiveRecord::Migration
  def self.up
    create_table :order_versions, :force => true do |t|
      t.references    :section
      t.references    :order
      t.integer       :version
      t.integer       :shipping_method_id
      t.string        :payment_method
      t.boolean       :shipped
      t.boolean       :paid
      t.boolean       :cancelled
      t.integer       :billing_address_id
      t.integer       :shipping_address_id
      t.datetime        :created_at
      t.datetime        :updated_at
      
    end
  end

  def self.down
    drop_table :product_images
  end
end
