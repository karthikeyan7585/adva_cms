scenario :section_with_active_product do
  
  @section = stub_section
  @order = stub_order
  @cart = stub_cart
    
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
  @section.products.stub!(:permalinks).and_return ['fifth-product']
end