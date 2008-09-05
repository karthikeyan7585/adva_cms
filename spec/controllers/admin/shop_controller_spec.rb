require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::ShopController do
  include SpecControllerHelper
  
  before :each do
    scenario :shop_with_active_product
    set_resource_paths :shop, 'shop'
    
  end
  
  it "should be an Admin::BaseController" do
    controller.should be_kind_of(Admin::BaseController)
  end
  
  describe "routing" do
    with_options :path_prefix => '/admin/sites/1/sections/2/', :site_id => "1", :section_id => "2" do |route|
      route.it_maps :get, "shop/show", :show, :id =>'show'
    end
  end
  
  describe "GET to :show" do    
    act! { request_to :get, @show_admin_shop_path }

    it "it should show the shop" do
      @site.sections.stub!(:find).should_not be_nil
    end
    
  end  
  
  describe "POST to :save_payment_setup" do
    act! { request_to :put, @save_payment_setup_path }  
    it "saves the payment setup" do
      @shop.stub!(:external_payment).should_not be_nil
    end
  end
end