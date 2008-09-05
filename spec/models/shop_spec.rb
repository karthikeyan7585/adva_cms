require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
    scenario :shop_with_active_product
  end
  
  it "is a kind of Section" do
    Shop.new.should be_kind_of(Section)
  end
  
  describe "associations" do
    it "has many products" do
      @shop.should have_many(:products)
    end
    
    it "has many orders" do
      @shop.should have_many(:orders)
    end
    
    it "has one external payment" do
      @shop.should have_one(:external_payment)
    end
    
    it "has one bank payment" do
      @shop.should have_one(:bank_payment)
    end
    
    it "has one credit card payment" do
      @shop.should have_one(:credit_card_payment)
    end
  end

  it "#selected_payment_methods returns an array of payment method names of the shop" do
    @shop.stub!(:selected_payment_methods).and_return 3
    @shop.selected_payment_methods.should == 3
  end
  
  it "#build_external_payment builds an external payment" do
    @shop.stub!(:external_payment).and_return stub_external_payment
    @shop.external_payment.should_not be_nil
  end
  
  it "#build_credit_card_payment builds a credit card payment" do
    @shop.stub!(:credit_card_payment).and_return stub_credit_card_payment
    @shop.credit_card_payment.should_not be_nil
  end
  
  it "#build_bank_payment builds a bank payment" do
    @shop.stub!(:bank_payment).and_return stub_bank_payment
    @shop.bank_payment.should_not be_nil
  end
end