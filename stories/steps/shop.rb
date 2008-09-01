factories :sections, :products

steps_for :shop do
  Given 'a shop' do
    @shop ||= begin
      Given 'a site'
      create_shop :site => @site
    end
  end
  
  Given "a shop with commented product" do
    Given "a shop"
    @product = create_product(:name => 'my product', :description => 'desc', :price => 123)
    @product.section = @shop
    @product.update_attributes! 'comment_age' => '3'
  end
  
  Given "a shop that allows anonymous users to create comments" do
    Given "a shop"
    @shop.update_attributes! 'permissions' => {'comment' => {'show' => 'anonymous', 'create' => 'anonymous'}}
  end
  
  Given 'a shop with no products' do
    Given "a shop"
    Product.delete_all
    @shop = create_shop
    @shop.products.should be_empty
    @product_count = 0
  end

  Given "a shop with a product" do
    Given "a shop"
    Product.delete_all
    @product = create_product
    @shop = @product.section
  end 
  
  Given "a shop with a category" do
    Given "a shop"
    Category.delete_all
    Section.delete_all
    @shop = create_shop
    @category = create_category :section => @shop
  end

  Given "a shop with no categories" do
    Given "a shop"
    Category.delete_all
    Section.delete_all
    @shop = create_shop
  end

  Given 'a shop product' do
    Given 'a shop'
    Product.delete_all
    Category.delete_all
    @product = create_product
    @product_count = 1
  end
  
  Given 'a shop with products' do
    Given 'a user has added a product with a quantity of 1 to the shopping cart'
  end

  When 'the user goes to the view cart page'do
     raise "step expects the variable @shop or @section to be set" unless @shop or @section
    section = @shop || @section
    get admin_products_path(section.site, section)
  end

  When 'the user goes to the shop products list page' do
    raise "step expects the variable @shop or @section to be set" unless @shop or @section
    section = @shop || @section
    get admin_products_path(section.site, section)
  end

  When 'the user changes the quantity for the product to 2' do
    get view_cart_path(section.site, section)
  end
  
  When 'the user changes the quantity for the product to 0'do
    get view_cart_path(section.site, section)
  end
  
  Then 'the cart info widget displays no cart contents' do
    get view_cart_path(section.site, section)
  end
  
  Then "the product is added to the cart with a quantity of 2" do
    get update_cart_path(section.site, section)
  end
  
  Then 'the quantity is updated in the cart' do
    get update_cart_path(section.site, section)
  end
  Then 'the product is removed from the cart' do
    get remove_from_cart_path(section.site, section)
  end
end
