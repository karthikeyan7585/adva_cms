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
           :title => 'A product',
           :permalink => 'fifth-product',
           :body_html => 'body html',
           :tag_list => 'sdf',
           :accept_comments? => true,
           :filter => nil,
           :save => true, 
           :update_attributes => true, 
           :has_attribute? => true,
           :destroy => true,
           :paginate_with_tags => [self],
           :find_by_id => self

  instance :product 
end