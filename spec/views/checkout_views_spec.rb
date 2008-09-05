
require File.dirname(__FILE__) + '/../spec_helper'
require 'base_helper'

describe "Shop:" do
  include SpecViewHelper
  
  before :each do
    @shop = stub_shop
    @products = stub_products
    @order = stub_order
    @order_lines = stub_order_lines
    @cart = stub_cart
    @cart_items = stub_cart_items
    
    assigns[:section] = @section = stub_section
    assigns[:site] = @site = stub_site
    
    
    set_resource_paths :shop, '/'
    
    template.stub!(:shop_path).and_return(@collection_path)
    template.stub!(:shop_path).and_return @shop_path
    template.stub!(:show_shop_path).and_return(@shows_shop_path)
    template.stub!(:will_paginate)
    
    template.stub_render hash_including(:partial => 'product_headers')
    template.stub_render hash_including(:partial => 'cart_info_widget')
    template.stub_render hash_including(:partial => 'product')
    template.stub_render hash_including(:partial => 'footer')
    template.stub_render hash_including(:partial => 'view_cart')
    template.stub_render hash_including(:partial => 'order_status')
    template.stub_render hash_including(:template => 'add_billing_details')
    template.stub_render hash_including(:partial => 'proceed_to_payment')
    template.stub_render hash_including(:partial => 'process_payment')
    
     (class << template; self; end).class_eval do
      include BaseHelper
    end        
  end
  
  describe "the index view" do
    before :each do
      assigns[:products] = stub_products
    end
    
    it "should display a list of products" do
      template.stub_render :partial => 'product', :collection => stub_products
    end
  end
  
  describe "the show" do
    before :each do
      assigns[:product] = stub_product
    end
    
    it "should display a product information " do
      template.stub_render :partial => 'view_product', :collection => stub_products
    end
  end
  
  describe "view cart" do
    before :each do
      assigns[:products] = stub_products
    end
    
    it "should display a product information " do
      template.stub_render :partial => 'view_cart', :collection => stub_products
    end
  end
  
  describe "add billing and shipping details" do
    before :each do
      assigns[:order] = stub_order
      assigns[:order_lines] = stub_order_lines
    end
    
    it "should display a product information " do
      template.stub_render :template => 'add_billing_details', :collection => stub_order_lines
    end
  end
  
  describe "add details and proceed to payment" do
    before :each do
      assigns[:order] = stub_order
      assigns[:order_lines] = stub_order_lines
    end
    
    it "should display a product information " do
      template.stub_render :template => 'proceed_to_payment', :collection => stub_order_lines
    end
  end
  
  describe "process and complete payment" do
    before :each do
      assigns[:order] = stub_order
      assigns[:order_lines] = stub_order_lines
    end
    
    it "should display a product information " do
      template.stub_render :template => 'process_payment', :collection => stub_order_lines
    end
  end
end
