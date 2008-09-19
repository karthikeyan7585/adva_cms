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
        :product_id => lambda{ (Product.find(:first) || create_active_product).id },
        :cart_id => lambda{ (Cart.find(:first) || create_cart).id },
        :product => lambda{ (Product.find(:first) || create_active_product) },
        :cart => lambda{ (Cart.find(:first) || create_cart) },
        :quantity => 1
     
factory :addresss,
        :full_name => 'full name 1',
        :street1 => 'street1',
        :street2 => 'street2',
        :city => 'city',
        :state => 'state',
        :country => 'United States',
        :zip_code => '123456',
        :phone => '123456789',
        :email => 'email@email.org',
        :addressable_type => '',
        :addressable_id => nil,
        :addressable => nil
        
factory :user_address,
        valid_addresss_attributes.update(
          :addressable_type => 'User',
          :addressable_id => lambda{ (User.find(:first) || create_user).id },
          :addressable => lambda{ (User.find(:first) || create_user) }),
        :class => :addresss
 