scenario :order_with_order_lines do
  scenario :empty_site

  @section = @shop = stub_section
  @order = stub_order
  @orders = stub_orders
  @order_line = stub_order_line
  @order_lines = stub_order_lines
    
  @order.stub!(:add_billing_details).and_return @order
  @order.stub!(:proceed_to_payment).and_return @order
  @order.stub!(:process_payment).and_return @order
  @order.stub!(:complete_external_payment).and_return @order
    
  Order.stub!(:find).and_return @order
  @shop.stub!(:orders).and_return @orders
  @order.order_lines.stub!(:find).and_return @order_lines
end
