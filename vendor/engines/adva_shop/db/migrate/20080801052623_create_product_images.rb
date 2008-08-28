class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images, :force => true do |t|
      t.integer  :product_id
      t.integer  :parent_id
      t.string   :content_type
      t.string   :filename
      t.integer  :size
      t.string   :thumbnail
      t.integer  :width
      t.integer  :height
      t.string   :title
      t.integer  :thumbnails_count, :default => 0
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :product_images
  end
end
