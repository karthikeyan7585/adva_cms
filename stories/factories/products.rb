Product.delete_all
Category.delete_all

factories :shop

factory :comment,
        :body       => 'the comment body',
        :site_id    => lambda{ (Site.find(:first) || create_site).id },
        :section_id => lambda{ (Shop.find(:first) || create_shop).id },
        :author_id  => lambda{ (User.find(:first) || create_user).id },
        :author     => lambda{ (User.find(:first) || create_user) },
        :commentable_type => 'Product',
        :commentable_id => lambda{ (Product.find(:first) || create_active_product).id }

factory :category,
        :title   => 'a category',
        :section => lambda{ Shop.find(:first) || create_shop }

factory :tag,
        :name => 'foo'

factory :product,
        :name => 'the product name',
        :description => 'the product description',
        :price => 100.0,
        :weight => 10.0,
        :tax_rate => 12.0,
        :quantity => 10,
        :vendor_name => 'vendor name',
        :cached_tag_list => 'foo',
        :active => true,
        :comment_age => -1,
        :permalink   => 'the-product-name',
        :site    => lambda{ Site.find(:first) || create_site },
        :section => lambda{ Shop.find(:first) || create_shop },
        :categories => lambda{ [Category.find_by_title('a category') || create_category] },
        :tag_list => 'foo bar'

factory :active_product, 
        valid_product_attributes.update(:active => true),
        :class => :product
        
        
factory :cart, :id => 1

factory :cart_item, 
        :product_id => lambda{ (Product.find(:first) || create_product).id },
        :cart_id => lambda{ (Cart.find(:first) || create_cart).id },
        :quantity => 1
        
#factory :product_category,
#        :product_id => lambda{ (Product.find(:first) || create_product).id },
#        :product => lambda{ (Product.find(:first) || create_product) },
#        :category_id => lambda{ (Category.find(:first) || create_category).id },
#        :category => lambda{ (Category.find(:first) || create_category) }        