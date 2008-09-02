require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::ProductsController do
  include SpecControllerHelper
  
  before :each do
    scenario :section_with_active_product
    set_resource_paths :product, '/admin/sites/1/sections/2/'
    @controller.stub! :require_authentication
    @controller.stub!(:has_permission?).and_return true
  end
  
  it "should be an Admin::BaseController" do
    controller.should be_kind_of(Admin::BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/admin/sites/1/sections/2/', :site_id => "1", :section_id => "2" do |route|
      route.it_maps :get, "products", :index
      route.it_maps :get, "products/3", :show, :id => '3'
      route.it_maps :get, "products/new", :new
      route.it_maps :post, "products", :create
      route.it_maps :get, "products/3/edit", :edit, :id => '3'
      route.it_maps :put, "products/3", :update, :id => '3'
      route.it_maps :delete, "products/3", :destroy, :id => '3'
    end
  end
  
  describe "GET to :index" do
    act! { request_to :get, @collection_path }    
    it_assigns :products
    
    
    describe "when the section is a Section" do
      before :each do @site.sections.stub!(:find).and_return @section end
      it_renders_template 'admin/products/index'
    end
    
    describe "when the section is a Shop" do
      before :each do @site.sections.stub!(:find).and_return stub_shop end
      it_renders_template 'admin/shop/index'
    end
    
    describe "filters" do
      it "should fetch products belonging to a category when :filter == category" do
        options = hash_including(:conditions => "category_assignments.category_id = 1")
        @section.products.should_receive(:paginate)
        request_to :get, @collection_path, :filter => 'category', :category => '1'
      end
      
      it "should fetch products by checking the name when :filter == name" do
        options = hash_including(:conditions => "LOWER(products.name) LIKE '%Fifth%'")
        @section.products.should_receive(:paginate)
        request_to :get, @collection_path, :filter => 'name', :query => 'Fifth'
      end
      
      it "should fetch products by checking the description when :filter ==description" do
        options = hash_including(:conditions => "LOWER(products.description) LIKE '%asdf%'")
        @section.products.should_receive(:paginate)
        request_to :get, @collection_path, :filter => 'description', :query => 'asdf'
      end
      
      it "should fetch products by checking the tags when :filter == tags" do
        options = hash_including(:conditions => "tags.name IN ('sdf','bike')")
        @section.products.should_receive(:paginate)
        request_to :get, @collection_path, :filter => 'tags', :query => 'sdf'
      end    
    end    
  end
  
  describe "GET to :show" do    
    act! { request_to :get, @member_path }
    it_assigns :product
    
  end  
  
  describe "GET to :new" do
    act! { request_to :get, @new_member_path }    
    it_assigns :product
    it_renders_template :new
    it "instantiates a new product from section.products" do
      @section.products.should_receive(:build).and_return @product
      act!
    end    
  end
  
  describe "POST to :create" do
    act! { request_to :post, @collection_path }    
    it_assigns :product 
    it "instantiates a new product from section.products" do
      @section.products.should_receive(:build).and_return @product
      act!
    end
  end
  
  describe "GET to :edit" do
    act! { request_to :get, @edit_member_path }    
    it_assigns :product
    it_renders_template :edit
    
    it "fetches an product from section.products" do
      @section.products.should_receive(:find).any_number_of_times.and_return @product
      act!
    end
  end 
  
  describe "PUT to :update" do
    
    act! { request_to :get, @edit_member_path }    
    it_assigns :product    
    it_renders_template :edit
    it "fetches an product from section.products" do
      
      @section.products.should_receive(:find).any_number_of_times.and_return @product
      act!
    end  
    
  end  
  
  
  describe "DELETE to :destroy" do
    act! { request_to :delete, @member_path }    
    it_assigns :product
    
    
    it "fetches an product from section.products" do
      @section.products.should_receive(:find).any_number_of_times.and_return @product
      act!
    end 
    
    it "should try to destroy the product" do
      @product.should_receive :destroy
      act!
    end 
  end    
  describe "when destroy succeeds" do
    act! { request_to :post, @collection_path }    
  end
  
  describe "when destroy fails" do
    before :each do @product.stub!(:destroy).and_return false end
  end
end



describe Admin::ProductsController, "page_cache" do
  include SpecControllerHelper
  
  before :each do
    @filter = Admin::ProductsController.filter_chain.find ProductSweeper.instance      
  end
  
  it "activates the ProductSweeper as an around filter" do
    @filter.should be_kind_of(ActionController::Filters::AroundFilter)
  end
  
  it "configures the ProductSweeper to observe Comment create, update, rollback and destroy events" do
    @filter.options[:only].should == [:create, :update, :destroy]
  end
end

describe "ProductSweeper" do
  include SpecControllerHelper
  controller_name 'admin/products'
  
  before :each do
    scenario :section_with_active_product
    @sweeper = ProductSweeper.instance
  end
  
  it "observes Product" do 
    ActiveRecord::Base.observers.should include(:product_sweeper)
  end
  
  it "should expire pages that reference the product's section when the product is a new record" do
    @product.stub!(:new_record?).and_return true
    @sweeper.should_receive(:expire_cached_pages_by_reference).with(@product.section)
    @sweeper.before_save(@product)
  end
  
  it "should expire pages that reference an product when the product is not a new record" do
    @product.stub!(:new_record?).and_return false
    @sweeper.should_receive(:expire_cached_pages_by_reference).with(@product)
    @sweeper.before_save(@product)
  end
end