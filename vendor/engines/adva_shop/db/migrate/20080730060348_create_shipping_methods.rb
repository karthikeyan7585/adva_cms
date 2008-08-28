class CreateShippingMethods < ActiveRecord::Migration
  def self.up
    create_table :shipping_methods, :force => true do |t|
      t.string  :name
      t.float   :shipping_cost
      t.references :section
    end
  end

  def self.down
    drop_table :customers
  end
end
