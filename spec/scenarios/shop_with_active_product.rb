scenario :shop_with_active_product do
  scenario :empty_site
  
  @section = @shop = stub_shop
  @product = stub_product
  @products = stub_products
  @category = stub_category(:category)
  @categories = stub_categories
  
  @product.stub!(:[]).with('type').and_return 'Product'
  
  Product.stub!(:find).and_return @product
  @category.stub!(:products).and_return(@products)
  @category.products.stub!(:paginate_with_tags).and_return @products
  @category.products.stub!(:find_by_id).and_return @product
  @shop.products.stub!(:paginate_with_tags).and_return @products
  @shop.products.stub!(:permalinks).and_return ['a-product']
  @shop.products.stub!(:find_by_id).and_return @product
  
  Category.stub!(:find).and_return @category
  Category.stub!(:find_by_path).and_return @category  
  
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
  
  Tag.stub!(:find).and_return stub_tags(:all)
  
  @site.sections.stub!(:find).and_return @shop
  @site.sections.stub!(:root).and_return @shop
end

