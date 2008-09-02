require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::OrdersController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop_orders
    set_resource_paths :order, '/admin/sites/1/sections/2/'
    @controller.stub! :require_authentication

  end
  
  it "should be an Admin::BaseController" do
    controller.should be_kind_of(Admin::BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/admin/sites/1/sections/2/', :site_id => "1", :section_id => "2" do |route|
      route.it_maps :get, "orders", :index
      route.it_maps :get, "orders/2/edit", :edit, :id => '2'
      route.it_maps :get, "orders/2/shipping_page", :shipping_page, :id => '2'
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
     it_assigns :order
      it_renders_template :edit
      
      it "fetches an order from orders" do
        @section.orders.should_receive(:find).any_number_of_times.and_return @order
        act!
      end
    end 
     describe "GET to :recive_payment" do
      act! { request_to :get, @receive_order_payment_path }    
     it_assigns :order

      
      it "received payment for order" do
        @order.receive_payment.should be_true
        act!
      end
      it "not received payment for order" do
        @order.receive_payment.should be_false
        act!
      end
    end 
     describe "GET to :ship_items" do
      act! { request_to :get, @ship_order_items_path }    
     it_assigns :order

      
      it "shipped order successully" do
        @order.ship_items.should be_true
        act!
      end
      it "shipped order not successully" do
        @order.ship_items.should be_false
        act!
      end
  end
 describe "GET to :cancel_order" do
      act! { request_to :get, @cancel_order_path }    
     it_assigns :order

      
      it "order cancelled" do
        @order.cancel_order.should be_true
        act!
      end
      it "order not cancelled" do
        @order.cancel_order.should be_false
        act!
      end
    end   
end
