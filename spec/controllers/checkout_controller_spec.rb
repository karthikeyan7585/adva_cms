require File.dirname(__FILE__) + "/../spec_helper"

describe CheckoutController do
  include SpecControllerHelper
  
  before :each do
    scenario :order_with_order_lines
  end
  
  it "should be an BaseController" do
    controller.should be_kind_of(BaseController)
  end
  
  describe "GET to :show" do
    before :each do 
      @order.stub!(:paid?).and_return false
      @order.stub!(:shipped?).and_return false
    end
    
    describe "When the user checks out the cart items" do
      describe "when the user checks out the cart items" do
        act! { request_to :get, '/shop/1/checkout/add_billing_details' } 
        
        it "creates the order gets the billing and shipping information from the customer" do
          @order.stub!(:add_billing_details).should_not be_nil
        end
      end
      
      describe "when gives the billing and shipping information and proceeds to the next step" do
        act! { request_to :get, '/shop/1/checkout/proceed_to_payment' } 
        
        it "saves the customer details and goes to the payment step" do
          @order.stub!(:proceed_to_payment).and_return @order
        end
      end
      
      describe "when the user gives the payment information for the purchase" do
        act! { request_to :get, '/shop/1/checkout/process_payment' } 
        
        it "creates the order gets the billing and shipping information from the customer" do
          @order.stub!(:process_payment).and_return @order
        end
      end
      
      describe "when the user has selected the external payment method" do
        act! { request_to :get, '/shop/1/checkout/complete_external_payment' } 
        
        it "gets the confirmation from the customer and completes the payment" do
          @order.stub!(:complete_external_payment).and_return @order
        end
      end
    end
  end
end