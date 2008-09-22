with_options :controller => "shop", :action => "index", :requirements => { :method => :get } do |shop|
  
  shop.shop                 "shops/:section_id"
  
  shop.shop_tag             "shops/:section_id/tags/:tags",
                            :requirements => { :method => :get }
  
  shop.render_cart_info_widget  "shops/:section_id/render_cart_info_widget", :action => 'render_cart_info_widget' 
  
  shop.shop_category        "shops/:section_id/categories/:category_id",
                            :requirements => { :method => :get }
                            
  shop.search_product       "shops/:section_id/search_product", :action => 'search_product'  
  
  shop.fetch_order_status   "shops/:section_id/fetch_order_status", :action => 'fetch_order_status'                          
  
end

with_options :controller => "admin/orders", :action => "index", :requirements => { :method => :get } do |order|
  
  order.shipping_page         "admin/sites/:site_id/sections/:section_id/orders/:id/shipping_page", :action => 'shipping_page'
  
  order.receive_order_payment "admin/sites/:site_id/sections/:section_id/orders/:id/receive_payment",
                              :action => "receive_payment"
 
  order.ship_order_items      "admin/sites/:site_id/sections/:section_id/orders/:id/ship_items",
                              :action => "ship_items"

  order.cancel_order          "admin/sites/:site_id/sections/:section_id/orders/:id/cancel_order",
                              :action => "cancel_order"
end

with_options :controller => 'checkout', :action => 'index', :requirements => {:method => :get} do |checkout|
  
  checkout.add_billing_details           "shops/:section_id/checkout/add_billing_details", :action => "add_billing_details"
  
  checkout.remove_address               "shops/:section_id/checkout/remove_address/:address_id", :action => "remove_address",
                                                                      :requirements => { :method => :delete }
  
  checkout.proceed_to_payment            "shops/:section_id/checkout/proceed_to_payment/:order_id", :action => "proceed_to_payment"
  
  checkout.process_payment               "shops/:section_id/checkout/process_payment/:order_id", :action => "process_payment"
  
  checkout.confirm_external_payment      "shops/:section_id/checkout/confirm_external_payment/:order_id", :action => 'confirm_external_payment'
  
  checkout.complete_external_payment     "shops/:section_id/checkout/complete_external_payment/:order_id", :action => 'complete_external_payment'
  
end

map.resources  :orders,     :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/"


map.shop                    "shops/:section_id",
                            :controller     => "shop",   
                            :action         => "index",
                            :requirements   => { :method => :get }
                     
map.resources :products,    :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/",
                            :member      => {:update_all => :put, :product_image => :get}

map.formatted_shop_comments 'shops/:section_id/comments.:format',
                            :controller   => 'shop',
                            :action       => "comments",
                            :requirements => { :method => :get }
                                
map.formatted_shop    'shops/:section_id.:format',
                            :controller   => 'shop',
                            :action       => "products",
                            :requirements => { :method => :get }

map.product                 "shops/:section_id/products/:permalink",
                            :controller     => "shop",   
                            :action         => "show",
                            :requirements   => { :method => :get }
                            
map.resources :addresses

map.resources :carts,       :path_prefix => "shops/:section_id"

map.resources :shop,        :path_prefix => "admin/sites/:site_id/sections/:section_id",
                            :name_prefix => "admin_",
                            :namespace   => "admin/",
                            :collection => {:save_payment_setup => :put}

