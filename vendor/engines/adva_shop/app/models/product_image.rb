class ProductImage < ActiveRecord::Base
  
  # Maximum size of the image file
  UPLOAD_LIMIT = 5
  
  has_attachment  :storage => :file_system,
                  :content_type => :image,
                  :thumbnails => {:thumb => [50, 50]},
                  :resize_to => [200, 200],
                  :max_size => UPLOAD_LIMIT.megabytes
       
  belongs_to :product
  
  # Validate the product image file. This method is used instead of "validates_as_attachment" method
  # to display the custom error messages 
  def validate
    # Images should only be GIF, JPEG, or PNG
    enum = attachment_options[:content_type]
    unless enum.nil? || enum.include?(send(:content_type))
      errors.add_to_base("can upload only images (GIF, JPEG, JPG, or PNG)")
    end
    # Images should be less than UPLOAD_LIMIT MB.
    enum = attachment_options[:size]
    unless enum.nil? || enum.include?(send(:size))
      msg = "should be smaller than #{UPLOAD_LIMIT} MB"
      errors.add_to_base(msg)
    end
  end
end