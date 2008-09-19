factories :user
#used "addresss" instead of "address" since got the issue http://pastie.org/273939
         factory :addresss,
              :id => 1,
             :full_name => 'Rob Williams',
             :street1 => 'New Street',
             :street2 => 'New Street2',
             :city => 'My City',
             :state => 'My State',
             :country => 'My Country',
             :zip_code => '123456',
             :phone => '999999999',
             :email => 'mymail@example.com'
             
#          factory :bank_addresss,
#              :id => 2,
#             :full_name => 'Bank',
#             :street1 => 'New Street',
#             :street2 => 'New Street2',
#             :city => 'My City',
#             :state => 'My State',
#             :country => 'My Country',
#             :zip_code => '123456',
#             :phone => '999999999',
#             :addressable_type => 'BankPayment',
#             :class => :address