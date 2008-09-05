define Order do
  belongs_to :site, stub_site
  belongs_to :section
  belongs_to :billing_address
  belongs_to :shipping_address
  belongs_to :shipping_method
  belongs_to :shop
  has_many   :order_lines
  
  methods    :id => 1,
             :section_id => 1,
             :receive_payment => 1,
             :status => 1,
             :ship_items => 1,
             :cancel_order => 1,
             :total_price =>100.00,
             :billing_address_id => 1,
             :shipping_address_id => 1,
             :shipping_status =>'Shipped',
             :payment_status =>'Paid',
             :completed? => false,
             :shipped? => false,
             :paid? => false
                          
  instance   :order
end

define OrderLine do
  belongs_to :order
  belongs_to :product
  
  methods    :id => 1,
             :order_id => 1,
             :product_id => 1,
             :quantity => 1,
             :total_price => 100.00,
             :tax_amount => 20
  
  instance   :order_line
end