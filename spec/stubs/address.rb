define Addresss do
  belongs_to :addressable, :polymorphic => true
  
  methods    :id => 1,
             :full_name => 'Rob Williams',
             :street1 => 'New Street',
             :street2 => 'New Street2',
             :city => 'My City',
             :state => 'My State',
             :country => 'My Country',
             :zip_code => '123456',
             :phone => '999999999',
             :email => 'mymail@example.com'
end