factories :products, :orders

steps_for :order do 
  
  Given 'a shop with one product and one order' do
    @product = create_active_product
    @shop = @product.section
    @order = create_order   
    @order.order_lines = [create_order_line]
  end
 
  Given 'a processed order' do
    @order ||= create_order   
  end
 
  When "the user visits the 'Orders' tab in the admin shop section" do
    raise "step expects the variable @shop to be set" unless @shop
    raise "step expects the variable @order to be set" unless @order
    get admin_orders_path(@shop.site, @shop)
  end
  
  When "the user clicks on the order link" do
    get edit_admin_order_path(@site, @shop, @order)
    response.should render_template('admin/orders/edit')
  end
  
  When "user filters the order list by an id" do
    selects 'with ID', :from => 'filter'
    fills_in 'query', :with => @order.id
    clicks_button 'Go'
  end

  When "user filters the order list by an product_id" do
    selects 'whose product ID is', :from => 'filter'
    fills_in 'query', :with => @order.order_lines.first.product_id
    clicks_button 'Go'
  end
  
  Then "the order list shows orders matching the product_id" do
    response.should have_tag('table.list')
  end
  
  When "the user enters the invalid product_id" do
    selects 'whose product ID is', :from => 'filter'
    fills_in 'query', :with => 0
    clicks_button 'Go'
  end
  
  Then "the order list does not show orders not matching the product_id" do
    response.should have_tag("div.empty")
  end
 
  When "user filters the order list by an user_id"  do
    selects 'whose user ID is', :from => 'filter'
    fills_in 'query', :with => @order.billing_address.addressable_id
    clicks_button 'Go'
  end
    
  Then "the order list shows orders matching the user_id"  do
    response.should have_tag('table.list')
  end
  
  When "the user enters the invalid user_id"  do
    selects 'whose user ID is', :from => 'filter'
    fills_in 'query', :with => 0
    clicks_button 'Go'
  end
  
  Then "the order list does not show orders not matching the user_id"  do
    response.should have_tag("div.empty")
  end
   
  When "user filters the order list by an keyword" do
    selects 'whose product name contains', :from => 'filter'
    fills_in 'query', :with => @order.order_lines.first.product.name
    clicks_button 'Go'
  end 
  
  Then "the order list shows orders matching the keyword" do
    response.should have_tag('table.list')
  end 
  
  When "the user enters the invalid keyword" do
    selects 'whose product name contains', :from => 'filter'
    fills_in 'query', :with => 'invalid name'
    clicks_button 'Go'
  end 
  
  Then "the order list does not show orders not matching the keyword" do
    response.should have_tag("div.empty")
  end 

  When "the user enters the invalid order id" do
    selects 'with ID', :from => 'filter'
    fills_in 'query', :with => 0
    clicks_button 'Go'
  end   
  
  When "user filters the order list by an status" do
    selects 'whose status is', :from => 'filter'
    selects 'New', :from => 'status'
    clicks_button 'Go'
  end
  
  Then "the order list shows orders matching the status" do
    response.should have_tag('table.list')
  end

  When "user filters the order list by an date" do
    selects 'ordered on', :from => 'filter'
    selects @order.created_at.year, :from => 'order[ordered_on(1i)]'
    selects Date::MONTHNAMES.fetch(@order.created_at.month), :from => 'order[ordered_on(2i)]'
    selects @order.created_at.day, :from => 'order[ordered_on(3i)]'
    clicks_button 'Go'
  end
  
  When "the user enters the invalid date" do
    selects 'ordered on', :from => 'filter'    
    selects @order.created_at.year.to_i + 1, :from => 'order[ordered_on(1i)]'
    selects Date::MONTHNAMES.fetch(@order.created_at.month), :from => 'order[ordered_on(2i)]'
    selects @order.created_at.day, :from => 'order[ordered_on(3i)]'
    clicks_button 'Go'
  end
  
  Then "the user has an order tracking number" do
     raise "step expects the variable @order to be set" unless @order
  end
  
  Then "the page has an order tracking form" do
    action = fetch_order_status_path(@shop)
    response.should have_form_posting_to(action)
  end
  
  Then "the page shows the order status page" do
    response.should have_tag("div.order_versions")
  end
  
  Then "the page lists the order's status changes grouped by: today, yesterday, older changes" do
     response.should have_tag("ul.order_versions")
  end
  
  When "the user goes to the shop order tracking page" do
    get "/#{@shop.permalink}"
    response.should render_template('shop/index')
    response.should have_tag("div#view_widget")
    response.should have_tag("div#view_widget1")
  end
  
  When "the user enters in the order tracking form with a valid order tracking number"  do
    fills_in 'order_id', :with => @order.id
  end
  
  When "the user clicks on the 'Find' icon" do
    response.should have_tag("input[type=?][value=?]", "image", "Find")
    get "/#{@shop.permalink}/fetch_order_status?order_id=#{@order.id}"
    response.should render_template('shop/fetch_order_status')
  end

  Then "the order list does not show orders not matching the date" do
    response.should have_tag("div.empty")
  end
  
  Then "the order list shows orders matching the date" do
    response.should have_tag('table.list')
  end

  Then "the order list shows orders matching the id" do
    response.should have_tag('table.list')
  end
  
  Then "the order list does not show orders not matching the id" do
    response.should have_tag("div.empty")
  end
  
  Then "the list has one entry" do
    response.should have_tag('a[href^=?]', "/admin/sites/#{@site.id}/sections/#{@shop.id}/orders/#{@order.id}/edit")
  end
  
  Then "the user sees the admin order edit page" do
    response.should render_template('admin/orders/edit')
  end
  
  Then "the user sees the admin orders list page" do
    raise "step expects the variable @shop to be set" unless @shop
    raise "step expects the variable @order to be set" unless @order
    response.should render_template('admin/orders/index')
  end
  
  Then "the page shows the order details" do
    response.should have_tag("div#order_shipping_address")
    response.should have_tag("div#order_billing_address")
    response.should have_tag("div#order_payment_method")
    response.should have_tag("div#order_version_info")
  end
  
  Then "the page shows a history order changes" do
    response.should have_tag("div#order_version_info")
  end
  
  Then "the page lists all orders that are not completed" do
    response.should render_template('admin/orders/index')
  end
  
  Then "the listed order has a 'Receive Payment' button" do
    get edit_admin_order_path(@site, @shop, @order)
    response.should have_tag("input[type=?][value=?]", "submit", "Receive Payment")
  end
  
  Then "the listed order has a 'Ship Items' button" do
    get edit_admin_order_path(@site, @shop, @order)
    response.should have_tag("input[type=?][value=?]", "submit", "Ship Items")
  end 
  
  Then "a payment receivement email is sent to the user" do
    @order.status = 2
    ShopMailer.deliver_payment_confirmation @order, shop_url(@shop)
  end
  
  Then "a shipping email is sent to the user" do
    @order.status = 3
    ShopMailer.deliver_shipment_confirmation@order, shop_url(@shop)
  end
  
  Then "the order's status set to \"completed\"" do
    @order.status.should >= 2
  end
  
  Then "the user is redirected back to the admin orders list page" do
    response.should render_template('admin/orders/index')
  end
  
  Then "the order's 'Receive Payment' button is removed" do
    response.should_not have_tag("input[type=?][value=?]", "submit", "Receive Payment")
  end
  
  Then "the listed order has a 'Shipping Paper' link" do
    response.should have_tag('a[href^=?]', "/admin/sites/#{@site.id}/sections/#{@shop.id}/orders/#{@order.id}/shipping_page")
  end
  
  Then "the user sees the order shipping paper view page"  do
    response.should render_template('admin/orders/shipping_page')
  end
  
  Then "the page has a Javascript 'Print Page' link" do   
    response.should have_tag("input[type=?][value=?]", "button", "Print Page")
  end
  
  Then "the order is not listed" do
     response.should_not have_tag('a[href^=?]', "/admin/sites/#{@site.id}/sections/#{@shop.id}/orders/#{@order.id}/edit")
  end
  
  Then "the page has a order filter bar for filtering by: id, date, status, product_id, keyword, user_id" do
    response.should have_tag('select#filterlist')
  end
  
end