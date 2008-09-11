require File.dirname(__FILE__) + '/../../spec_helper'
require 'base_helper'

describe "Admin::Products:" do
  include SpecViewHelper
  
  before :each do
    @product = stub_product
    @products = stub_products
    
    @product.stub!(:comment_age).and_return 0
    @products.stub!(:total_entries).and_return 1
    
    assigns[:section] = @section = stub_section
    assigns[:site] = @site = stub_site
    assigns[:categories] = @categories = stub_categories

    set_resource_paths :product, '/admin/sites/1/sections/2/'
    
    template.stub!(:admin_products_path).and_return(@collection_path)
    template.stub!(:admin_product_path).and_return(@member_path)
    template.stub!(:new_admin_product_path).and_return @new_member_path
    template.stub!(:edit_admin_product_path).and_return(@edit_member_path)
    template.stub!(:will_paginate)
    
    template.stub_render hash_including(:partial => 'options')
    template.stub_render hash_including(:partial => 'categories/checkboxes')
    template.stub_render hash_including(:partial => 'admin/assets/widget/widget')
    
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
      render "admin/shop/index", :collection => stub_products
      response.should have_tag('table[class=list]')
    end
  end
  
  describe "the new view" do
    before :each do
      assigns[:product] = @product
    end
    
    it "should render the form partial" do
      template.expect_render hash_including(:partial => 'form')
      render "admin/products/new"
    end
  end
  
  describe "the edit view" do
    before :each do
      assigns[:product] = @product
    end
    
    it "should render the form partial" do
      template.expect_render hash_including(:partial => 'form')
      render "admin/products/new"
    end
  end
  
  describe "the form partial" do
    before :each do
      assigns[:product] = @product
    end
    
    it "should render the product form fields" do
      render "admin/products/_form"
      response.should have_tag('input[name=?]', 'product[name]')
      response.should have_tag('textarea[name=?]', 'product[description]')
    end
  end
  
  describe "the options partial" do
    before :each do
      assigns[:product] = @product
    
      @product.stub!(:assets).and_return []
      @site.stub!(:assets).and_return mock('assets_proxy', :recent => [])
      template.stub!(:bucket_assets)

      template.stub!(:f).and_return ActionView::Base.default_form_builder.new(:product, @product, template, {}, nil)
      template.stub!(:filter_options).and_return []
      template.stub!(:comment_expiration_options).and_return []  
    end
    
    it "should render the categories/checkboxes partial" do
      template.expect_render hash_including(:partial => 'categories/checkboxes')
      render "admin/products/_options"
    end
    
    it "should render the assets/widget/widget partial" do
      template.expect_render hash_including(:partial => 'admin/assets/widget/widget')
      render "admin/products/_options"
    end
  end
end
