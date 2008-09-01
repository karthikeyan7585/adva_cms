class Cart < ActiveRecord::Base  
  has_many :cart_items, :dependent => :destroy
  has_many :products, :through => :cart_items  
  
end