factories :shop, :products

steps_for :article do
  
  When "the user clicks on \"Products\"" do
    get admin_products_path(@site, @shop)
  end
  
  When "the user fills in the admin product creation form with valid values" do
    fills_in 'name', :with => 'the product name'
    fills_in 'product[description]', :with =>'the product description'
    fills_in 'product[price]', :with => '100'
  end
  
  When "the user fills in the product edit form with valid values" do
    fills_in 'name', :with => 'the product name'
    fills_in 'product[description]', :with =>'the product description'
    fills_in 'product[price]', :with => '200'
  end
  
  When "the user fills in the product picture" do
  end

  When "the user selects filtering by keyword in description" do
    selects 'whose name contains', :from => 'filter'
  end
  
  When "the user fills in the keyword" do
    fills_in 'query', :with => 'the product name'
  end
  
  When "the user hits the enter key" do
    clicks_button 'Go'
  end
  
  When "the user checks 'Active'" do
    checks 'product_active'
  end
  
  Then "the page has an \"empty\" list of products" do
    response.should have_tag("div.empty")
  end
  
  Then "the page has a product creation form" do
    raise "step expects the variable @shop to be set" unless @shop
    action = admin_products_path(@shop.site, @shop)
    response.should have_form_posting_to(action)
    @product_count = Product.count
  end
  
  Then "the page has an edit product form" do
    raise "step expects the variable @shop to be set" unless @shop
    action = admin_product_path(@shop.site, @shop, @product)
    response.should have_form_putting_to(action)
    @product_count = Product.count
  end
  
  Then "a new product is saved" do
    raise "step expects @product_count to be set" unless @product_count
    (@product_count + 1).should == Product.count
  end
  
  Then "the product is updated" do
    product = Product.find_by_name "the product name"
    product.should_not be_nil
  end
  
  Then "the product is deleted" do
    product = Product.find_by_name "the product name"
    product.should be_nil
  end
  
  Then "the user is redirected to the admin shop products list page" do
    request.request_uri.should =~ %r(/admin/sites/[\d]*/sections/[\d]*/products)
    response.should render_template("admin/shop/index")
  end
  
  Then "the user is redirected to the product listing page" do
    Then "the user is redirected to the admin shop products list page"
  end
  
  Then "the page has a list of products" do
    response.should have_tag('table.list')
  end

  Then "each product has an edit link" do
    response.should have_tag('a[href^=?]', "/admin/sites/#{@site.id}/sections/#{@shop.id}/products/#{@product.id}/edit")
  end
  
  Then "the page has the product filter bar for filtering by: Category, tags, keywords (in name/description)" do
    response.should have_tag('select#filterlist')
  end
  
  Then "the page has a lists of filtered products" do
    response.should have_tag('table.list')
  end
end