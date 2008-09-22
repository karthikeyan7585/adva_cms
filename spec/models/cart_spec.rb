require File.dirname(__FILE__) + '/../spec_helper'

describe Cart do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
    scenario :cart_with_cart_items
  end
  
  describe "associations" do
    it "has many products" do
      @cart.should have_many(:products)
    end
    
    it "has many cart items" do
      @cart.should have_many(:cart_items)
    end
  end
end