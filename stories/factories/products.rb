Product.delete_all
Category.delete_all

factories :user, :sections

factory :shop, valid_section_attributes.update(:type => 'Shop', :title => 'the shop title'),
        :class => :section

factory :comment,
        :body       => 'the comment body',
        :site_id    => lambda{ (Site.find(:first) || create_site).id },
        :section_id => lambda{ (Shop.find(:first) || create_section).id },
        :author_id  => lambda{ (User.find(:first) || create_user).id },
        :author     => lambda{ (User.find(:first) || create_user) }, # wtf ...
        :commentable_type => 'Product',
        :commentable_id => lambda{ (Product.find(:first) || create_product).id }

factory :category,
        :title   => 'a category',
        :section => lambda{ Shop.find(:first) || create_section }

factory :tag,
        :name => 'foo'

factory :product,
        :title   => 'the product title',
        :site    => lambda{ Site.find(:first) || create_site },
        :section => lambda{ Shop.find(:first) || create_section },
        :categories => lambda{ [Category.find_by_title('a category') || create_category] },
        :tag_list => 'foo bar'

        
