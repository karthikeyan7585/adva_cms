class ProductImage < ActiveRecord::Base
  has_attachment  :storage => :file_system,
                  :content_type => :image,
                  :thumbnails => {:thumb => [50, 50]},
                  :resize_to => [200, 200],
                  :max_size => 5.megabytes
       
  validates_as_attachment
  
  belongs_to :product
end