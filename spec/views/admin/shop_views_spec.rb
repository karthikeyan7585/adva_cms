require File.dirname(__FILE__) + '/../../spec_helper'
require 'base_helper'

describe "Admin::Shop:" do
  include SpecViewHelper
  
  before :each do
    @shop = stub_shop
    @products = stub_products
    
    assigns[:section] = @section = stub_section
    assigns[:site] = @site = stub_site
    
    
    set_resource_paths :shop,  '/admin/sites/1/sections/2/'
    
    template.stub!(:shop_path).and_return(@collection_path)
    template.stub!(:shop_path).and_return @shop_path
    template.stub!(:show_shop_path).and_return(@shows_shop_path)
    template.stub!(:will_paginate)
    
    template.stub_render hash_including(:partial => 'external_payment_form')
    template.stub_render hash_including(:partial => 'credit_card_payment_form')
    template.stub_render hash_including(:partial => 'bank_payment_form')
    
    
     (class << template; self; end).class_eval do
      include BaseHelper
    end        
  end
  
  describe "the index view" do
    before :each do
      assigns[:products] = stub_products
    end
    
    it "should display a list of products" do
      template.stub_render @admin_shop_path
    end
  end
  
  describe "the show" do
    before :each do
      assigns[:products] = stub_products
    end
    
    it "should display a list of products" do
      template.stub_render @show_admin_shop_path
    end
  end
  
end
