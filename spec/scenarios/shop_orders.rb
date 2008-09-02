scenario :shop_orders do
  scenario :empty_site
  
  @order = stub_shop
  @orders = stub_orders
  
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
end

