require File.dirname(__FILE__) + '/../../spec_helper'
require 'base_helper'

describe "Admin::Orders:" do
  include SpecViewHelper
  
  before :each do
    @order = stub_order
    @orders = stub_orders
    
    @order.stub!(:created_at).and_return Time.zone.now
    
    assigns[:section] = @section = stub_section
    assigns[:site] = @site = stub_site
    
    
    set_resource_paths :order, '/admin/sites/1/sections/2/'
    
    template.stub!(:admin_orders_path).and_return(@collection_path)
    template.stub!(:admin_order_path).and_return(@member_path)
    template.stub!(:shipping_page_path).and_return("#{@member_path}/shipping_page")
    template.stub!(:receive_order_payment_path).and_return("#{@member_path}/receive_payment")
    template.stub!(:ship_order_items_path).and_return("#{@member_path}/ship_items")
    template.stub!(:cancel_order_path).and_return("#{@member_path}/cancel_order")
    
    @order.stub!(:billing_address).and_return Stubby::Instances.lookup('addresss', :first)
    @order.stub!(:shipping_address).and_return Stubby::Instances.lookup('addresss', :first)
    template.stub!(:will_paginate)
    
    
     (class << template; self; end).class_eval do
      include BaseHelper
    end        
  end
  
  describe "the index view" do
    before :each do
      assigns[:orders] = stub_orders
    end
    
    it "should display a list of orders" do
      @orders.stub!(:total_entries).and_return 1
      render "admin/orders/index", :collection => @orders
      response.should have_tag('table[class=list]')
    end
  end
  
  describe "the edit view" do
    before :each do
      assigns[:order] = @order
    end
    
    it "should render the order edit form" do
      render "admin/orders/edit", :object => @order
    end
  end
  
  describe "the shipping page" do
    before :each do
      assigns[:order] = @order
    end
    
    it "should render the shipping page" do
      render "admin/orders/shipping_page", :object => @order
    end
  end
end
