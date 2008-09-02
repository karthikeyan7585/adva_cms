require File.dirname(__FILE__) + "/../spec_helper"

describe ShopController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop
   set_resource_paths :shop, 'shop'

  end
  
  it "should be an BaseController" do
    controller.should be_kind_of(BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/' do |route|
      route.it_maps :get, "shop", :index
      route.it_maps :get, "shop/show", :show, :id =>'show'
    end
  end
  
  describe "GET to :index" do
    act! { request_to :get, @collection_path }    
    it_assigns :shop
    
    
    describe "when the section is a Section" do
      before :each do @site.sections.stub!(:find).and_return @section end
      it_renders_template '/index'
    end
end    

    end