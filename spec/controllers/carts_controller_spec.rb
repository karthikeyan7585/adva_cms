require File.dirname(__FILE__) + "/../spec_helper"

describe CartsController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop_with_active_product
    scenario :order_with_order_lines
    scenario :cart_with_cart_items
    set_resource_paths :cart, '/shops/1/'
  end
  
  it "should be an BaseController" do
    controller.should be_kind_of(BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/shops/1/', :section_id => "1" do |route|
      route.it_maps :get, "carts/1", :show, :id => '1'
      route.it_maps :post, "carts", :create
      route.it_maps :put, "carts/1", :update, :id => '1'
      route.it_maps :delete, "carts/1", :destroy, :id => '1'
    end
  end

  describe "GET to :show" do
    act! { request_to :get, @member_path }    
    
    it_assigns :product
    
    it "should find cart items" do
      @cart.cart_items.should_receive(:find).any_number_of_times.and_return [@cart_item]
      act!
    end  
  end
  
  describe "GET to :create" do
    act! { request_to :post, @collection_path }
    
    it "should add the new cart item" do
      @cart.cart_items.stub!(:build).and_return @cart_item
      act!
    end  
  end
  
  describe "GET to :create" do
        
    act! { request_to :post, @collection_path }
    
    it "should add the new cart item" do
      @cart.cart_items.stub!(:build).and_return @cart_item
      act!
    end  
  end
  
  describe "PUT to :update" do
    it "fetches a cart item from cart.cart_items" do
      @cart.cart_items.should_receive(:find).any_number_of_times.and_return @cart_item
    end  
    
    it "should update the cart item" do
      @cart_item.stub!(:attributes=).and_return true
    end  
  end
  
  describe "DELETE to :destroy" do
    it "fetches a cart item from cart.cart_items" do
      @cart.cart_items.should_receive(:find).any_number_of_times.and_return @cart_item
    end  
    
    it "should remove the cart item" do
      @cart_item.stub!(:destroy).and_return true
    end  
  end
end