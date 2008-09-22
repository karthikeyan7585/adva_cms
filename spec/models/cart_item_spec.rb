require File.dirname(__FILE__) + '/../spec_helper'

describe CartItem do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
    scenario :cart_with_cart_items
  end
  
  describe "associations" do
    it "belongs to a cart" do
      @cart_item.should belong_to(:cart)
    end
    
    it "belongs to a product" do
      @cart_item.should belong_to(:product)
    end
  end
end