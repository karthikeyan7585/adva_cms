class CreateProductCategories < ActiveRecord::Migration
  def self.up
    create_table :product_categories, :force => true do |t|
      t.references    :product
      t.references    :category
    end
  end

  def self.down
    drop_table :product_categories
  end
end
