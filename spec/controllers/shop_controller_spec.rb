require File.dirname(__FILE__) + "/../spec_helper"

describe ShopController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop_with_active_product
    scenario :cart_with_cart_items
    set_resource_paths :shop, 'shop'
  end
  
  it "should be an BaseController" do
    controller.should be_kind_of(BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/' do |route|
      route.it_maps :get, "shop", :index
      route.it_maps :get, "shop/1", :show, :id => '1'
    end
  end
  
  describe "GET to :show" do
    before :each do 
      @product.stub!(:active?).and_return true
    end
    
    act! { request_to :get, '/shop/fifth-product' }    
    it_assigns :section, :product
    
    describe "with an article permalink given" do
      act! { request_to :get, '/shop/fifth-product' }  
      
      describe "when the article is published" do
        it_renders_template :show
      end
      
      it "should find the section's active product" do
        @section.products.should_receive(:find_by_permalink).any_number_of_times.and_return @product
        act!
      end
      
      describe "when the product is not active" do
        before :each do 
          @product.stub!(:active?).and_return false
          @product.stub!(:role_authorizing).and_return Role.build(:author)
        end
        
        describe "and the user has :update permissions" do
          before :each do 
            controller.stub!(:current_user).and_return stub_model(User, :has_role? => true)
          end
          
          it_renders_template :show
        end
        
        describe "and the user does not have :update permissions" do
          before :each do 
            controller.stub!(:current_user).and_return stub_model(User, :has_role? => false)
          end          
        end
      end
    end
  end
  
  describe "Cart" do
    it "adds a product to a cart" do
      @cart.stub!(:add_to_cart).should_not be_nil
    end
    
    it "display the cart items" do 
      @cart.stub!(:view_cart).should_not be_nil
    end
    
    it "display the cart items" do 
      @cart.stub!(:update_cart).should_not be_nil
    end
  end
end

describe "Shop page_caching" do
  
  include SpecControllerHelper
  
  describe ShopController do
    it "page_caches the :index action" do
      cached_page_filter_for(:index).should_not be_nil
    end
    
    it "tracks read access for a bunch of models for the :index action page caching" do
      ShopController.track_options[:index].should == ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
    end
    
    it "page_caches the :show action" do
      cached_page_filter_for(:show).should_not be_nil
    end
    
    it "tracks read access for a bunch of models for the :show action page caching" do
      ShopController.track_options[:index].should == ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
    end
    
    it "page_caches the comments action" do
      cached_page_filter_for(:comments).should_not be_nil
    end
    
    it "tracks read access on @commentable for comments action page caching" do
      ShopController.track_options[:comments].should include('@commentable')
    end
  end
end