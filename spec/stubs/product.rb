define Product do
  has_many :comments, :build => stub_comment
  has_many [:approved_comments, :unapproved_comments], stub_comments
  has_many :categories
  has_many :tags
  has_one  :comments_counter, stub_counter
  has_one  :product_image
  
  belongs_to :site
  belongs_to :section
  belongs_to :author, stub_user

  methods  :id => 1,
           :type => 'Product',
           :name => 'A product',
           :description => 'product description',
           :permalink => 'a-product',
           :tag_list => 'prod',
           :active? => true,
           :active => true,
           :weight => 10.0,
           :quantity => 1,
           :accept_comments? => true,
           :filter => nil,
           :save => true,
           :update_attributes => true, 
           :has_attribute? => true,
           :destroy => true,
           :paginate_with_tags => [self],
           :find_by_id => self,
           :price => 100.0,
           :tax_rate => 12.0,
           :vendor_name => 'Vendor',
           :product_image => nil

  instance :product 
end