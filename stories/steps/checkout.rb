factories :products, :payment_methods

steps_for :checkout do 
  
  Given "the user is a registered user" do
    Given "the user is logged in as user"
    @user.addresses = [create_user_address]
  end
  
  Given "credit card payment processing is configured properly and available" do
    @shop.credit_card_payment = create_credit_card_payment
  end
  
  Given "online payment processing is not configured properly or not available" do
    @shop.bank_payment = create_bank_payment
  end
  
  Given "online payment processing is configured properly and available" do
    @shop.external_payment = create_external_payment
  end
  
  When "the user fills in the billing address form with valid data" do
    fills_in "email", :with => 'test@example.com'
    fills_in "billing_address_full_name", :with => 'Full Name'
    fills_in "billing_address_street1", :with => 'street1'
    fills_in "billing_address_street2", :with => 'street2'
    fills_in "billing_address_city", :with => 'city'
    fills_in "billing_address_state", :with => 'state'
    selects "United States", :from => "billing_address_country"
    fills_in "billing_address_zip_code", :with => '123456'
    fills_in "billing_address_phone", :with => '123456789'
  end
  
  When "the user checks the \"use my billing address for shipping\" checkbox" do
    checks "ship_to_billing_address"
  end
  
  When "the user unchecks the \"use my billing address for shipping\" checkbox" do
    unchecks "ship_to_billing_address"
  end
  
  When "the user fills in the shipping address form with valid data" do
    fills_in "email", :with => 'test@example.com'
    fills_in "shipping_address_full_name", :with => 'Full Name 2'
    fills_in "shipping_address_street1", :with => 'street1 2'
    fills_in "shipping_address_street2", :with => 'street2 2'
    fills_in "shipping_address_city", :with => 'city 2'
    fills_in "shipping_address_state", :with => 'state 2'
    selects "United States", :from => "shipping_address_country"
    fills_in "shipping_address_zip_code", :with => '1234562'
    fills_in "shipping_address_phone", :with => '1234567892'
  end
  
  When "the user selects the \"Use a different billing address\" radio button" do
    chooses "selected_billing_address_new_new"
  end
  
  When "the user selects the \"Use a different shipping address\" radio button" do
    chooses "selected_shipping_address_new_new"
  end
  
  When "the user selects a payment option" do
    chooses "payment_method_creditcardpayment"
  end
  
  When "the user fills in the payment information form with valid data" do
    fills_in "credit_card_first_name", :with => 'Steve'
    fills_in "credit_card_last_name", :with => 'Smith'
    selects "Visa", :from => 'credit_card_type'
    fills_in "credit_card_number", :with => '4059042064101342'
    selects "01", :from => 'credit_card_month'
    selects "2017", :from => 'credit_card_year'
    fills_in 'credit_card_verification_value', :with => '962'
  end
  
  When "the user selects bank payment option" do
    chooses "payment_method_bankpayment"
  end
  
  When "the user selects external payment option" do
    chooses "payment_method_externalpayment"
  end
  
  When "the user clicks on the external payment image link" do
    @order = Order.find(session[:order_id])
    get "/#{@shop.permalink}/checkout/process_payment/#{@order.id}?payment_method=ExternalPayment"
  end
  
  Then "the user sees the checkout page" do
    response.should render_template("checkout/add_billing_details")
    @order = Order.find(session[:order_id])
  end
  
  Then "the page displays the cart contents including detailed price information" do
    response.should have_tag("div#cart_products")
  end
  
  Then "the page has a billing address form" do
    response.should have_tag("div#billing_address_form")
  end
  
  Then "the page has a shipping address form" do
    response.should have_tag("div#shipping_address_form")
  end
  
  Then "the page the shipping address form is hidden" do
    response.should have_tag("div#shipping_address") # condition should be more clear
  end
  
  Then "the page has a checkbox \"use my billing address for shipping\" which is checked by default" do
    response.should have_tag("input#ship_to_billing_address[type=?][checked=?]", "checkbox", "checked")
  end
  
  Then "the checkbox \"use my billing address for shipping\" unveils the shipping address form when unchecked" do
    unchecks "ship_to_billing_address"
    response.should have_tag("div#shipping_address") # condition should be more clear
  end
  
  Then "the page has radio buttons for selecting a billing address (listing the user's addresses)" do
    response.should have_tag("input[type=?][name=?][value=?]", "radio", "selected_billing_address", "#{@user.addresses.first.id}")
  end
  
  Then "the first address is selected as a billing address by default" do
    response.should have_tag("input[type=?][name=?][value=?][checked=?]", "radio", "selected_billing_address", "#{@user.addresses.first.id}", "checked")
  end
  
  Then "the page has a radio button \"Use a different billing address\" which unveils the billing address form when selected" do
    response.should have_tag("input[type=?][name=?][value=?]", "radio", "selected_billing_address", "new")
  end
  
  Then "the page has a billing address form which is hidden by default" do
     response.should have_tag("div#billing_address_form")
  end
  
  Then "the page has a checkbox \"Use my billing address for shipping\" which is checked by default" do
    response.should have_tag("input#ship_to_billing_address[type=?][checked=?]", "checkbox", "checked")
  end
  
  Then "the checkbox \"Use my billing address for shipping\" unveils the shipping address form (and address radio buttons) when unchecked" do
    unchecks "ship_to_billing_address"
    response.should have_tag("div#shipping_address_form")
  end
  
  Then "the page has radio buttons for selecting a shipping address (listing the user's addresses)" do
    response.should have_tag("input[type=?][name=?][value=?]", "radio", "selected_shipping_address", "#{@user.addresses.first.id}")
  end
  
  Then "the first address is selected as a shipping address by default" do
    response.should have_tag("input[type=?][name=?][value=?][checked=?]", "radio", "selected_shipping_address", "#{@user.addresses.first.id}", "checked")
  end
  
  Then "the page has a radio button \"Use a different shipping address\" which unveils the shipping address form when selected" do
    response.should have_tag("input[type=?][name=?][value=?]", "radio", "selected_shipping_address", "new")
  end
  
  Then "the page has a shipping address form which is hidden by default" do
    response.should have_tag("div#shipping_address_form")
  end
  
  Then "the user checks the \"Use my billing address for shipping\" checkbox" do
    checks "ship_to_billing_address"
  end
  
  Then "the billing address is stored with the shopping cart" do
    @order = Order.find(session[:order_id])
    @order.billing_address.should_not be_nil
  end
  
  Then "the shipping address is stored with the shopping cart" do
    @order = Order.find(session[:order_id])
    @order.shipping_address.should_not be_nil
  end
  
  Then "the user's first address is stored with the shopping cart as the billing address" do
    @order = Order.find(session[:order_id])
    @user.addresses.include?(@order.billing_address).should be_true
  end
  
  Then "the user's first address is stored with the shopping cart as the shipping address" do
    @order = Order.find(session[:order_id])
    @user.addresses.include?(@order.shipping_address).should be_true
  end
  
  Then "no separate shipping address is stored with the shopping cart" do
    @order.shipping_address.id.should == @order.billing_address.id
  end
  
  Then "the user is redirected to the review order page" do
    response.should render_template("checkout/proceed_to_payment")
  end
  
  Then "user's new address is saved" do
    @order = Order.find(session[:order_id])
    @order.billing_address.should_not be_nil
    @order.shipping_address.should_not be_nil
  end
  
  Then "the new address is stored with the shopping cart as the billing address" do
    @order = Order.find(session[:order_id])
    @user = User.find(session[:uid])
    @user.addresses.include?(@order.billing_address).should be_true
  end
  
  Then "the new address is stored with the shopping cart as the shipping address" do
    @order = Order.find(session[:order_id])
    @user = User.find(session[:uid])
    @user.addresses.include?(@order.shipping_address).should be_true
  end
  
  Then "the page displays the shipping and billing address information" do
    # Should be implemented
  end
  
  Then "the page has a payment information form" do
    @order = Order.find(session[:order_id])
    response.should have_tag("div#credit_card_details")
  end
  
  Then "the payment details are displayed" do
    response.should have_tag("div#bank_details")
  end
  
  Then "the payment is processed" do
    # The following line will pass only if the payment is successful otherwise it will render the error page 
    # response.should render_template("checkout/process_payment")
    # or
    # response.should render_template("checkout/error")
  end
  
  Then "the user is redirected to a confirmation page" do
    response.should render_template("checkout/process_payment")
  end
  
  Then "the confirmation page shows the details of the order" do
    response.should have_tag("div#order_confirmation_details")
  end
  
  Then "the user is redirected to the external payment website" do
  end
  
  Then "the user completes the payment" do
  end
  
  # Email verifications should be done for the stories
  Then "a confirmation email is sent to the user" do
  end
  
  Then "the confirmation email contains the details of the order" do
  end
  
end