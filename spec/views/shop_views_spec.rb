
require File.dirname(__FILE__) + '/../spec_helper'
require 'base_helper'

describe "Shop:" do
  include SpecViewHelper
  
  before :each do
    @shop = stub_shop
    @products = stub_products
    
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
  
end
