define Cart do
  has_many :cart_items, :build => stub_cart_item
  has_many :products, :through => :cart_items, :build => stub_product
  
  methods  :id => 1
                          
  instance :cart
end
