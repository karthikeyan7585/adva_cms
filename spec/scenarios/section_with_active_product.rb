scenario :section_with_active_product do
  scenario :empty_site

  @section = stub_section
  @product = stub_product
  @products = stub_products
    
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
  @section.products.stub!(:permalinks).and_return ['a-product']
end