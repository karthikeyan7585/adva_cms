define Shop do
  belongs_to :site

  has_many :products, [:find, :find_by_permalink, :find_published_by_permalink, :build, :primary] => stub_products,
                      [:roots, :paginate, :paginate_published_in_time_delta] => stub_products,
                      :permalinks => ['fifth-product'], :maximum => 4
                      
  has_many :categories, [:find, :build, :root, :find_by_path] => stub_category, 
                        [:paginate, :roots] => stub_categories
        
  has_many :comments, :build => stub_comment
  has_many [:approved_comments, :unapproved_comments], stub_comments
  has_one  :comments_counter, stub_counter

  methods  :id => 1,
           :type => 'Shop', 
           :path => 'shop',
           :name => 'shop name', 
           :permalink => 'shop',
           :comment_age => 0,
           :render_options => {},
           :template => 'template',
           :layout => 'layout',
           :content_filter => 'textile-filter',
           :valid? => true,
           :has_attribute? => true,
           :payment_setup_saved? => true,
           :bank_payment => nil,
           :credit_card_payment => nil,
           :external_payment => nil
  instance :shop
  
  instance :shops_shop,
           :path => 'shops/shop'
end