require File.dirname(__FILE__) + '/../spec_helper'
require 'base_helper'

describe "Cart:" do
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
    
     (class << template; self; end).class_eval do
      include BaseHelper
    end        
  end
  
  describe "the show" do
    before :each do
      assigns[:cart] = @cart
    end
    
    it "should display the cart with cart items " do
      template.stub_render :partial => 'view_cart', :object => @cart
    end
  end
  
  describe "the create" do
    before :each do
      assigns[:cart] = @cart
      assigns[:cart_item] = @cart_item
    end
    
    it "should add an item to the cart" do
      template.stub_render :template => 'shop/product', :collection => @products
    end
  end
  
  describe "the update" do
    before :each do
      assigns[:cart] = @cart
      assigns[:cart_item] = @cart_item
    end
    
    it "should update the quantity of the item in the cart" do
      template.stub_render :template => 'view_cart', :object => @cart
    end
  end
  
  describe "the destroy" do
    before :each do
      assigns[:cart] = @cart
      assigns[:cart_item] = @cart_item
    end
    
    it "should remove the item from the cart" do
      template.stub_render :template => 'view_cart', :object => @cart
    end
  end
end
