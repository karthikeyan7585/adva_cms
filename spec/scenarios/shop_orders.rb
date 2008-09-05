scenario :shop_orders do
  scenario :empty_site
  
  @section = @shop = stub_section
  @order = stub_order
  @orders = stub_orders
  
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
end

