require File.dirname(__FILE__) + "/../spec_helper"

describe ShopController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop_with_active_product
    scenario :order_with_order_lines
    set_resource_paths :shop, 'shop'
  end
  
  it "should be an BaseController" do
    controller.should be_kind_of(BaseController)
  end
  
  describe "GET to :index" do
    before :each do 
      @product.stub!(:active?).and_return true
    end
    
    act! { request_to :get, '/shops/1' }    
    it_assigns :products
    
    describe "with a shop id given" do
      it_renders_template :index
      it_gets_page_cached
      
      it "should find the section's article" do
        @section.products.should_receive(:all).any_number_of_times.and_return [@product]
        act!
      end  
    end
    
  end

  describe "GET to :show" do
    before :each do 
      @product.stub!(:active?).and_return true
    end
    
    act! { request_to :get, '/shops/1/products/a-product' }    
    it_assigns :product
    
    describe "with a product permalink given" do
      it_renders_template :show
      it_gets_page_cached
      
      it "should find the section's product" do
        @section.products.should_receive(:primary).any_number_of_times.and_return [@product]
        act!
      end  
    end
  end
  
  describe "GET to :fetch_order_status" do
    act! {request_to :get, '/shops/1/fetch_order_status'}
    it_renders_template :fetch_order_status
  end
  
  describe "GET to :search_product" do
    act! {request_to :get, '/shops/1/search_product'}
    it_assigns :products
    it_renders_template :index
  end
end

describe "Shop page_caching" do
  
  include SpecControllerHelper
  
  describe ShopController do
    it "tracks read access for a bunch of models for the :index action page caching" do
      ShopController.track_options[:index].should == ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
    end
    
    it "tracks read access for a bunch of models for the :show action page caching" do
      ShopController.track_options[:index].should == ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
    end
    
    it "tracks read access on @commentable for comments action page caching" do
      ShopController.track_options[:comments].should include('@commentable')
    end
  end
end