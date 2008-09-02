define Order do
  belongs_to :site, stub_site
  belongs_to :section
  belongs_to :billing_address
  belongs_to :shipping_address
  belongs_to :shipping_method
  belongs_to :shop
  
  methods    :receive_payment => 1,
             :paid => false,
             :shipped => false,
             :cancelled =>false,
             :ship_items => 1,
             :cancel_order => 1,
             :total_price =>100.00,
             :shipping_status =>'Shipped',
             :payment_status =>'Paid',
             :completed? => true
  
                          
  instance   :order,
             :id => 1,
             :title => 'order name'


end