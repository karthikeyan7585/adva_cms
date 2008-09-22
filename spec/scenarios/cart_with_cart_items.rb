scenario :cart_with_cart_items do
  scenario :empty_site

  @section = @shop = stub_section
  @cart = stub_cart
  @carts = stub_carts
  @cart_item = stub_cart_item
  @cart_items = stub_cart_items
    
  Cart.stub!(:find).and_return @cart
  @shop.stub!(:cart).and_return @cart
  @cart.cart_items.stub!(:find).and_return @cart_items
  @cart.cart_items.stub!(:build).and_return @cart_item
  @cart.cart_items.stub!(:select).and_return @cart_item
  @cart_item.stub!(:destroy).and_return true
end