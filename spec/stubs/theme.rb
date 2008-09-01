define Theme do
  has_many :theme_files, :_as => :files, :find => stub_theme_file
  has_one  :comments_counter, stub_counter
  
  instance :theme,
           :id => 'theme-1',
           :name => 'Theme 1',
           :version => '1',
           :author => 'author',
           :author_link => 'author_link',
           :homepage => 'homepage',
           :summary => 'summary',
           :path => '/path/to/themes/site-1/theme-1/',
           :save => true,
           :update_attributes => true,
           :destroy => true,
           :errors => []
end


