class CreateOrderLines < ActiveRecord::Migration
  def self.up
    create_table :order_lines, :force => true do |t|
      t.references    :product
      t.references    :order
      t.integer       :quantity
      
    end
  end

  def self.down
    drop_table :order_lines
  end
end
