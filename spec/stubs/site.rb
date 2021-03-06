define Site do
  has_many :sections, [stub_section, stub_wiki, stub_blog, stub_forum,stub_shop],
                      [:find, :build, :root] => stub_section, 
                      :paths => ['section', 'sections/section', 'blog', 'blogs/blog','shop','shops/shop', 
                                 'forums/forum', 'forum', 'wikis/wiki', 'wiki']
  has_many :themes, [:find, :build, :root] => stub_theme
  has_many :users, :build => stub_user
  has_many :users_and_superusers, stub_users
        
  has_many :comments, [:find, :build] => stub_comment, :paginate => stub_comments
  has_many [:approved_comments, :unapproved_comments], stub_comments
        
  has_many :cached_pages, :find => stub_cached_page, 
                          :paginate => stub_cached_pages, 
                          :delete_all => nil, 
                          :total_entries => 2
  has_one  :comments_counter, stub_counter
                     
  methods  :id => 1,
           :name => 'site-1',
           :host => 'test.host',
           :perma_host => 'test-host',
           :title => 'site title' ,
           :subtitle => 'site subtitle',
           :email => 'foo@bar.baz' ,
           :timezone => 'timezone',
           :articles_per_page => 15,
           :comment_filter => 'comment_filter',
           :theme_names => ['theme-1'],
           :current_themes => [],
           :current_theme? => true,
           :section_ids => [1],
           :valid? => true,
           :save => true,
           :update_attributes => true,
           :destroy => true,
           :unapproved_comments => [], # wtf
           :activities => [],
           :current_theme_template_paths => [],
           :current_theme_layout_paths => [],
           :has_attribute? => true,
           :spam_filter_active? => false,
           :role_context => stub_site,
           :page_cache_directory => RAILS_ROOT + '/tmp/cache'
        
  instance :default          
end
