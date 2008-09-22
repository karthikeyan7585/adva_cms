define Product do
  has_many :comments, :build => stub_comment
  has_many [:approved_comments, :unapproved_comments], stub_comments
  has_many :categories
  has_many :tags
  has_one  :comments_counter, stub_counter
  
  belongs_to :site
  belongs_to :section
  belongs_to :author, stub_user

  methods  :id => 1,
           :type => 'Product',
           :name => 'A product',
           :permalink => 'a-product',
           :tag_list => 'prod',
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
           :vendor_name => 'Vendor'

  instance :product 
end