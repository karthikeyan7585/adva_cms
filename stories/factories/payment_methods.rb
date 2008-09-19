factories :shop,:sections,:addresses

factory :payment_method,
        :section_id => lambda{ (Shop.find(:first) || create_shop).id },
        :payment_type => '',
        :payment_attributes =>{}
        
factory :external_payment, valid_payment_method_attributes.update(
          :payment_type => 'ExternalPayment',
          :payment_attributes =>{
            :payment_gateway => 'ActiveMerchant::Billing::PaypalExpressGateway',
            :account_email => 'mymail@example.com'
          })

factory :credit_card_payment, valid_payment_method_attributes.update(
          :payment_type => 'CreditCardPayment',
          :payment_attributes =>{
            :payment_gateway => 'ActiveMerchant::Billing::PaypalGateway',
            :account_email => 'mymail@example.com',
            :accepted_cards => {:visa => true}
          })
          
factory :bank_payment, valid_payment_method_attributes.update(
          :payment_type => 'BankPayment',
          :payment_attributes=>{
            :bank_code =>'12345',
            :iban_number => '12345',
            :swift_code => '12345'
          },
          :address => lambda{ Address.find(:first) || create_addresss})
      