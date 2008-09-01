class CreateCartItems < ActiveRecord::Migration
   def self.up
    create_table :cart_items, :force => true do |t|
      t.references    :product
      t.references    :cart
      t.integer       :quantity     
    end
  end

  def self.down
    drop_table :cart_items
  end
end
