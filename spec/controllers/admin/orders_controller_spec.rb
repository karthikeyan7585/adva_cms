require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::OrdersController do
  include SpecControllerHelper
  
  before :each do
    scenario :order_with_order_lines
    set_resource_paths :order, '/admin/sites/1/sections/1/'
    @controller.stub! :require_authentication
    @controller.stub!(:has_permission?).and_return true
    @receive_order_payment_path = '/admin/sites/1/sections/1/orders/1/receive_payment'
    @ship_order_items_path = '/admin/sites/1/sections/1/orders/1/ship_items'
    @cancel_order_path = '/admin/sites/1/sections/1/orders/1/cancel_order'
  end
  
  it "should be an Admin::BaseController" do
    controller.should be_kind_of(Admin::BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/admin/sites/1/sections/1/', :site_id => "1", :section_id => "1" do |route|
      route.it_maps :get, "orders", :index
      route.it_maps :get, "orders/1/edit", :edit, :id => '1'
      route.it_maps :get, "orders/1/shipping_page", :shipping_page, :id => '1'
    end
  end
  
  describe "GET to :index" do
    act! { request_to :get, @collection_path }    
    it_assigns :orders
    
    
    describe "when the section is a Section" do
      before :each do @site.sections.stub!(:find).and_return @section end
      it_renders_template 'admin/orders/index'
    end
    
  end
  
  describe "GET to :edit" do
    act! { request_to :get, @edit_member_path }    
    
    it "fetches an order from orders" do
      @section.orders.should_receive(:find).any_number_of_times.and_return @order
      act!
    end
  end 
  
  describe "PUT to :recive_payment" do
    act! { request_to :put, @receive_order_payment_path }    
    
    it "received payment for order" do
      @order.stub!(:receive_payment).and_return true
      @order.receive_payment.should be_true
    end
  
    it "not received payment for order" do
      @order.stub!(:receive_payment).and_return false
      @order.receive_payment.should be_false
    end
  end 
  
  describe "PUT to :ship_items" do
    act! { request_to :put, @ship_order_items_path }    
    
    it "shipped order successully" do
      @order.stub!(:ship_items).and_return true
      @order.ship_items.should be_true
    end
    
    it "shipped order not successully" do
      @order.stub!(:ship_items).and_return false
      @order.ship_items.should be_false
    end
  end
  
  describe "PUT to :cancel_order" do
    act! { request_to :put, @cancel_order_path }    
    
    it "order cancelled" do
      @order.stub!(:cancel_order).and_return true
      @order.cancel_order.should be_true
    end

    it "order not cancelled" do
      @order.stub!(:cancel_order).and_return false
      @order.cancel_order.should be_false
    end
  end   
end
