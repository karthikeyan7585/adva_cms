define Cart do
  has_many :cart_items, :dependent => :destroy
  has_many :products, :through => :cart_items   
  
  methods    :id => 1
                          
  instance   :cart
end
