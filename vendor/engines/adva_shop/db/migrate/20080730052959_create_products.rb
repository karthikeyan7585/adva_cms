class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products, :force => true do |t|
      t.references    :site
      t.references    :section
      t.string        :name
      t.text          :description
      t.float         :price
      t.float         :weight
      t.float         :tax_rate
      t.integer       :quantity
      t.string        :vendor_name
      t.string        :permalink
      t.integer       :comment_age
      t.integer       :comment_counts
      t.boolean       :active
      t.string        :cached_tag_list
      t.datetime      :created_at
      t.datetime      :updated_at
      t.string        :filter
      t.datetime      :published_at
      t.string        :title
    end
  end

  def self.down
    drop_table :products
  end
end
