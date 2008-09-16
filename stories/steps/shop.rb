factories :products

steps_for :shop do 
  Given 'a shop' do
    @shop ||= begin
      Given 'a site'
      create_shop :site => @site
    end
  end
  
  Given "a site with a shop section" do
    Site.delete_all
    Shop.delete_all
    @site = create_site
    @shop = create_shop :site => @site
  end
  
  Given 'a site with no shops' do
    Site.delete_all
    Section.delete_all
    @site = create_site
  end
  
  Given 'a shop with no products' do
    Product.delete_all
    @shop = create_shop
    @shop.products.should be_empty
    @product_count = 0
  end
  
  Given 'a shop with products' do
    Product.delete_all
    Category.delete_all
    @product = create_active_product
    @shop = @product.section
    @category = create_category :section => @shop
    @shop.categories = [@category]
    @product.categories = [@category]
  end
  
  Given "a shop with commented product" do
    Product.delete_all
    Category.delete_all
    @product = create_active_product :comment_age => 0
    @shop = @product.section
    @comment = create_comment :commentable => @product, :approved => 1
  end
  
  Given "the user visits the shop section" do
    raise "step expects the variable @shop to be set" unless @shop
    get "/#{@shop.permalink}"
  end
  
  Given "product commenting for anonymous users is allowed" do
    @product = create_active_product :comment_age => 0
    @shop.update_attributes! 'permissions' => {'comment' => {'show' => 'anonymous', 'create' => 'anonymous'}}
  end
  
  Given "product commenting for registered users is allowed" do
    @product = create_active_product :comment_age => 0
    @shop.update_attributes! 'permissions' => {'comment' => {'show' => 'user', 'create' => 'user'}}
  end
  
  Given "an anonymous user" do
  end

  Given "a user has added a product to the shopping cart" do
    Given "an anonymous user"
    @cart_item = create_cart_item
    @cart = @cart_item.cart
  end
  
  When "the user clicks on 'Details' of a product" do
    get "/shop/products/#{@product.permalink}"
  end
     
  When "the user clicks sortable table column header" do
    link = find_link "Name"
    link.click
  end
  
  When "the user fills in the form with a comment" do
    fills_in 'comment_body', :with => 'the comment body'
  end
  
  When "the user goes to the shop products list page" do
    raise "step expects the variable @shop to be set" unless @shop
    get "/#{@shop.permalink}"
  end
  
  When "the user fills in a product quantity with 2" do
    raise "step expects the variable @shop to be set" unless @shop
    fills_in "product_quantity_#{@product.id}", :with => '2'
  end
  
  Then "the page has categories list section" do
    response.should have_tag("div#categories_widget")
    response.should have_tag("div#categories_widget1")    
  end
    
  Then "the page has a list of products filtered by category" do
    response.should render_template('shop/index')
    response.should have_tag('td.row2')
    @product.categories.first.title.should == @category.title
  end
  
  Then "the page has a list of products in catalogue" do
    response.should render_template('shop/index')
    response.should have_tag('td.row2')
  end
  
  Then "the page is paginated" do
    
  end

  Then "the page shows the details for the product" do
    response.should render_template('shop/show')
  end
  
  Then "the page has the 'Add to cart' button" do
    response.should have_tag("input[type=?][value=?]", "submit", "Add to cart")
  end
  
  Then "the page has a form field for specifying the product quantity" do
    response.should have_tag("input[type=?][id=?]", "text", "product_quantity_#{@product.id}")
  end
  
  Then "each product has a form field for specifying the product quantity" do
    response.should have_tag("input[type=?][id=?]", "text", "product_quantity_#{@product.id}")
  end
  
  Then "the product quantity is set to 1 by default" do
    response.should have_tag("input[type=?][id=?][value=?]", "text", "product_quantity_#{@product.id}", "1")
  end
  
  Then "each product has a \"Add to cart\" button" do
    response.should have_tag("input[type=?][value=?]", "submit", "Add to cart")
  end
  
  Then "the product is added to the cart with a quantity of 1" do
    Cart.delete_all
    CartItem.delete_all
    @cart_item = create_cart_item
    @cart = @cart_item.cart
  end
  
  Then "the cart info widget displays the cart contents" do
    response.should have_tag("div#cart_widget1")
  end
  
  Then "the cart info widget displays no cart contents" do
  end
  
  Then "the cart info widget does not display a link to \"View Cart\"" do
    @cart.should be_nil
    response.should_not have_tag("a[href^=?]", "#{@shop.permalink}/carts")
  end
  
  Then "the cart info widget displays a link to \"View Cart\"" do
    response.should have_tag('div#cart_info_widget')
    response.should_not have_tag('img#cart_spinner')
  end
  
  Then "the user is returned to the product list" do
    response.should render_template('shop/index')
  end
  
  Then "the products will be sorted by the table column header" do
  end
  
  Then "the table indicates the sorting column and direction (using CSS)" do
  end
  
  Then "the page has the product search field for filtering by: keywords (in name/description)" do
    response.should have_tag("input[id=?]", "search_term")
  end
  
  Then "the page has a list of approved comments" do
    response.should have_tag("div#comments")
    response.should have_tag("li#comment_#{@comment.id}")
  end
  
  Then "a new comment is created" do
    response.should have_tag("div#comments")
    @product.comments.count.should == 1
    @post = @product.comments.first
    @post.body.should == 'the comment body'
  end
  
  Then "the product has one unapproved comment more" do
    @product.comments.first.approved.should == 0
  end
  
  Then "the form contains comment field" do
    response.should have_tag("textarea#comment_body")
  end
  
  Then "the product has one approved comment more" do
    @product.comments.first.approved.should == 1
  end
  
  Then "the product is added to the cart with a quantity of 2" do
    @cart = Cart.find(session[:cart_id])
    @cart.cart_items.first.quantity.should == 2
  end
  
  Then "the page has a list of the shopping cart contents" do
    response.should have_tag("div#cart_content")
    @cart.cart_items.size.should > 0
  end
  
  Then "the page shows the summary of order costs and totals" do
    response.should have_tag('td[class*=?]', "row1a") do |td|
      td.should have_text("Total ")
    end
  end
  
 
  #### ADMIN
  
  Given "a shop with one product" do
    Product.delete_all
    @product = create_product
    @shop = @product.section
  end 
  
  Given "a shop with one deactivated product" do
    Product.delete_all
    @product = create_product :active => false
    @shop = @product.section
  end
  
  When "the user visits the admin area" do
    When "the user clicks on the \"sections\" link"
  end
  
  When "the user clicks on the \"sections\" link" do
    raise "step expects the variable @site to be set" unless @site
    get new_admin_section_path(@site)
  end
  
  When "the user selects \"shop\" as a section type" do
    chooses 'Shop'
  end
  
  When "the user fills in the shop title" do
    fills_in 'title', :with => 'a new shop'
  end
  
  When "the user visits the shop edit page" do
    get admin_section_path(@site, @shop)
  end
  
  When "the user fills in information about payment type selection and payment gateways" do
    fills_in 'title', :with => 'a new shop title'
    fills_in 'permalink', :with => 'a-new-shop-title'
  end
  
  When "the user goes to the shop products list page on the frontend" do
    raise "step expects the variable @shop to be set" unless @shop
    get "/#{@shop.permalink}"
  end
  
  When "the user goes to the products list on backend" do
    get admin_products_path(@shop.site, @shop)
  end
  
  Then "the page has a form fieldset for shop specific settings" do
    action = admin_section_path(@site, @shop)
    response.should have_form_putting_to(action)
  end
  
  Then "the page has a radio button for \"shop\" type" do
    raise "step expects the variable @site to be set" unless @site
    response.should have_tag("input#section_type_shop[type=?][value=?]", 'radio', 'Shop')
  end
  
  Then "a new shop section is created" do
    @shop = Shop.find_by_title 'a new shop'
    @shop.should_not be_nil
  end
  
  Then "The user is redirected to the shop edit page" do
    request.request_uri.should =~ %r(/admin/sites/[\d]*/sections/[\d]*)
    response.should render_template('admin/sections/show')
  end
  
  Then "the shop settings will be updated" do
    @shop = Shop.find_by_title 'a new shop title'
    @shop.should_not be_nil
  end
  
  Then "the product is not displayed on the frontend" do
    response.should render_template('shop/index')
    response.should_not have_tag('td.row2')
  end
  
  Then "the product is displayed on the frontend" do
    response.should have_tag('td.row2')
  end
end