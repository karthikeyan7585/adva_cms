factories :products

steps_for :order do
  Given 'An anonymous user only adds a billing address to an order'do
    Given 'the page displays the cart contents including detailed price information'
    Given 'the page displays the shipping and billing address information'
    Given'the page has a payment information form'
    get proceed_to_payment_path(section.site, section)
  end
  Given 'a shop with one product' do
    
  end
  Given 'a shop with products and a placed order' do
    
  end
  
  
   When 'the user selects a payment option' do
     When 'the user fills in the payment information form with valid data'
      fills_in 'name', :with => 'Pay Pal'
   end
   When 'the user clicks the "Pay order" button'do
     get proceed_to_payment_path(section.site, section)
   end
    
  When 'the user visits the $Orders tab in the admin shop section' do
    raise "step expects the variable @shop or @section to be set" unless @shop
    get admin_orders_path(@shop.site, @shop)
  end
  When 'the user fills in the order edit form with valid values' do
    fills_in 'shipped', :with => '1'
    fills_in 'paid', :with =>'1'
    fills_in 'cancelled', :with => '1'
  end
  
  When 'the user clicks on the "receive payment" button for the order' do
    raise "step expects the variable @order.paid to be set" unless @order
    get receive_order_payment_path(section.site, section, @order)
  end
  
  When 'the user clicks on the "shipping paper" link for the order' do
    get shipping_page_path(section.site, section, @order)
  end
  When 'the user clicks on the "ship order" button for the order' do
    get ship_order_items_path(section.site, section, @order)
  end
  When 'the user clicks on an order link' do
    get edit_admin_orders_path(section.site, section, @order)  
  end
  When 'the user goes to the shop order tracking page' do
    get order_track_path(section.site, section, @order)
  end
  When 'the user enters in the order tracking form with a valid order tracking number' do
    When 'the user clicks on show button'
    fills_in 'order_id', :with => '1'
    
  end
   When 'the payment is processed' do
     confirm_payment_path(section.site, section)
   end
  Then 'the payment is processed' do
    Then ' the user is redirected to a confirmation page'
    complete_payment_path(section.site, section)      
  end
  Then 'the user sees the admin orders list page' do
    get admin_orders_path(section.site, section, @order)  
  end
  Then ' a payment receivement email is sent to the user ' do
    get admin_receive_order_payment_path(section.site, section, @order)  
  end
  Then 'the page lists all orders that are not completed'do
    Then 'the listed order has a "shipping paper" link'
    get admin_orders_path(section.site, section, @order)  
  end
  Then 'the user sees the order shipping paper view page' do
    Then 'the page has a Javascript "Print" link'
    get shipping_page_path(section.site, section, @order)  
  end
  Then 'the page shows the order details 'do
    Then' the page shows a history order changes'
    get edit_admin_orders_path#order version
  end
  Then 'the page has an order tracking form' do
    get order_track_path(section.site, section, @order)
  end
  Then 'the page shows the order status page' do
    Then 'the page lists the orders status changes grouped by: today, yesterday, older changes'
    order_track_page_path(section.site, section, @order) 
  end
end
