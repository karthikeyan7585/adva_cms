factories :products,:shop,:addresses

factory :order,
        :billing_address => lambda{ Address.find(:first) || create_addresss },
        :shipping_address =>  lambda{ Address.find(:first) || create_addresss },
        :payment_method => 'PaymentMethod::ExternalPayment',
        :section_id => lambda{ (Shop.find(:first) || create_shop).id },
        :status => 1,
        :created_at => Time.now