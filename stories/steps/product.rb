factories :sections, :products

steps_for :product do
  
  Given 'a shop with no products' do
     Product.delete_all
  end
Given 'a shop with one product' do
   Product.delete_all
end
 Given 'a shop with one deactivated product' do
   Product.delete_all
 end
  Then "a new product is saved" do
    raise "step expects @product_count to be set" unless @product_count
    (@product_count + 1).should == Product.count
  end

  Then "the product is deleted" do
    raise "step expects @product_count to be set" unless @product_count
    (@product_count - 1).should == Product.find(:all).size
  end
  
  # ADMIN VIEW

  When "user clicks on  products" do |section|
    raise "step expects the variable @shop or @section to be set" unless @shop or @section
    section = @shop || @section
    get admin_products_path(section.site, section)
  end

  When "the user fills in the admin product creation form with valid values" do
    fills_in 'name', :with => 'the product name'
    fills_in 'product[tag_list]', :with => '\"test product\"'
  end

  When "the user clicks on the product link" do
    raise "step expects the variable @product to be set" unless @product
    When "the user clicks on '#{@product.name}'"
  end

  When "the user visits the admin shop product creation page" do
    raise "step expects the variable @shop or @section to be set" unless @shop
    get new_admin_product_path(@shop.site, @shop)
    @product_count = 0
  end

  When "the user clicks $section  edit " do |section|
    raise "step expects the variable @product and @shop or @section to be set" unless @product and (@shop or @section)
    section = @shop || @section
    get edit_admin_product_path(section.site, section, @product)
    @product_count = Product.count
    When "the user unchecks the  '#{@product.active}'" 
  end
  
  When "the user clicks $section  edit " do |section|
    raise "step expects the variable @product and @shop or @section to be set" unless @product and (@shop or @section)
    section = @shop || @section
    get edit_admin_product_path(section.site, section, @product)
    @product_count = Product.count
  end
  
  Then "the page has an admin product creation form" do
    raise "step expects the variable @section or @shop to be set" unless @shop or @section
    section = @shop || @section
    action = admin_products_path(section.site, section)
    response.should have_form_posting_to(action)
    @product_count = Product.count
  end

  Then "the page has an edit product form" do
    raise "step expects the variable @product and @shop or @section to be set" unless @product and (@shop or @section)
    section = @shop || @section
    action = admin_product_path(section.site, section, @product)
    response.should have_form_putting_to(action)
    @product_count = Product.count
  end

  Then "the page has a list of products" do
    response.should have_tag('table#products.list')
  end

  Then "the user is redirected to the product listing page" do
    request.request_uri.should =~ %r(/admin/sites/[\d]*/sections/[\d]*/products)
    response.should render_template("admin/shop/index")
  end
  
  Then "the user is redirected to the admin shop products list page" do
    request.request_uri.should =~ %r(/admin/sites/[\d]*/sections/[\d]*/products)
    response.should render_template("admin/products/index")
  end

  Then "the user is redirected to the admin $section products edit page" do
    request.request_uri.should =~ %r(/admin/sites/[\d]*/sections/[\d]*/products/[\d]*/edit)
    response.should render_template('edit')
  end

   
end
