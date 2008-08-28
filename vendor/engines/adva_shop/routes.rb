
with_options :controller => "shop", :action => "index", :requirements => { :method => :get } do |shop|
  
  shop.shop                 "shops/:section_id"
  
  shop.shop_tag             "shops/:section_id/tags/:tags",
                            :requirements => { :method => :get }
  
  shop.shop_category        "shops/:section_id/categories/:category_id",
                            :requirements => { :method => :get }
                            
  shop.view_cart            "shops/:section_id/view_cart", :action => 'view_cart'
  
  shop.update_cart          "shops/:section_id/update_cart", :action => 'update_cart'
  
  shop.remove_from_cart     "shops/:section_id/remove_from_cart", :action => 'remove_from_cart'
  
  shop.select_addresses     "shops/:section_id/select_addresses", :action => 'select_addresses'
  
  shop.proceed_to_payment   "shops/:section_id/proceed_to_payment", :action => 'proceed_to_payment'
  
  shop.process_payment      "shops/:section_id/process_payment", :action => 'process_payment'
  
  shop.confirm_payment      "shops/:section_id/confirm_payment", :action => 'confirm_payment'
  
  shop.complete_payment      "shops/:section_id/complete_payment", :action => 'complete_payment'
end

with_options :controller => "admin/orders", :action => "index", :requirements => { :method => :get } do |order|
  order.shipping_page        "admin/sites/:site_id/sections/:section_id/orders/:id/shipping_page", :action => 'shipping_page'
  order.receive_order_payment "admin/sites/:site_id/sections/:section_id/orders/:id/receive_payment",
                            :action => "receive_payment"
 
  order.ship_order_items "admin/sites/:site_id/sections/:section_id/orders/:id/ship_items",
                            :action => "ship_items"

  order.cancel_order "admin/sites/:site_id/sections/:section_id/orders/:id/cancel_order",
                            :action => "cancel_order"
end

map.resources  :orders,     :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/"


map.shop "shops/:section_id",
                            :controller     => "shop",   
                            :action         => "index",
                            :requirements   => { :method => :get }
                     
map.resources :products,    :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/",
                            :member      => {:update_all => :put, :product_image => :get}

map.resources :shop, :member => {:add_product_to_cart => :get}

map.address_create          "addressc/",
                            :controller     => "addresses",   
                            :action         => "create",
                            :requirements   => { :method => :get }
                            
map.formatted_shop_comments    'shops/:section_id/comments.:format',
                                :controller   => 'shop',
                                :action       => "comments",
                                :requirements => { :method => :get }
                                
map.product                 "shops/:section_id/:permalink",
                            :controller     => "shop",   
                            :action         => "show",
                            :requirements   => { :method => :get }
                            
map.resources :addresses       

map.resources :shop,        :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/",
                            :collection => {:save_payment_setup => :put}
