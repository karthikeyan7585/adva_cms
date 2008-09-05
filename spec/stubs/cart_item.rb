define CartItem do
  belongs_to :cart
  belongs_to :product
  
  methods    :id => 1,
             :product_id => 1,
             :cart_id => 1,
             :quantity => 1
  
  
                          
  instance   :cart_item
end