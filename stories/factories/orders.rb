factories :products,:shop

factory :order,
        :billing_address => lambda{ Address.find(:first) || create_user_address },
        :shipping_address =>  lambda{ Address.find(:first) || create_user_address },
        :payment_method => 'PaymentMethod::ExternalPayment',
        :section_id => lambda{ (Shop.find(:first) || create_shop).id },
        :status => 1,
        :created_at => Time.now
        
factory :order_line,
        :product_id => lambda{ (Product.find(:first) || create_product).id },
        :order_id  => lambda{ (Order.find(:first) || create_order).id },
        :quantity => 1