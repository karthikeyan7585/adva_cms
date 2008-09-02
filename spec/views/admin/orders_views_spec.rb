
require File.dirname(__FILE__) + '/../../spec_helper'
require 'base_helper'

describe "Admin::Orders:" do
  include SpecViewHelper
  
  before :each do
    @order = stub_order
    @orders = stub_orders
    
    assigns[:section] = @section = stub_section
    assigns[:site] = @site = stub_site


    set_resource_paths :order, '/admin/sites/1/sections/2/'
    
    template.stub!(:admin_orders_path).and_return(@collection_path)
    template.stub!(:admin_order_path).and_return(@member_path)
    template.stub!(:shipping_page_path).and_return @shipping_page_path
    template.stub!(:receive_order_payment_path).and_return(@receive_order_payment_path)
    template.stub!(:will_paginate)
    
  
    (class << template; self; end).class_eval do
      include BaseHelper
    end        
  end
  
  describe "the index view" do
    before :each do
      assigns[:orders] = stub_order
    end
    
    it "should display a list of orders" do

      render "admin/orders/index"
      response.should have_tag('table[id=orders]')
    end
  end
   describe "the edit view" do
    before :each do
      assigns[:order] = @order
    end
    
    it "should render the order edit form" do
      render "admin/orders/edit"
    end
  end
     describe "the shipping page" do
    before :each do
      assigns[:order] = @order
    end
    
    it "should render the shipping page" do
      render "admin/orders/shipping_page"
    end
  end
 end
