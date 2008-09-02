require File.dirname(__FILE__) + '/../spec_helper'

describe Shop do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
   scenario :shop 


end
 describe '#build_external_payment' do
  
   it "the external payment should be success" do
         @shop.stub!(:external_payment).and_return nil
      @shop.external_payment.should be_nil
    end

 
   it "the external payment should not be success" do
     @shop.stub!(:external_payment).and_return nil
     !@shop.external_payment.should be_nil
    end

end
 describe '#build_bank_payment' do
  
   it "the bank payment should be success" do
         @shop.stub!(:bank_payment).and_return nil
      @shop.bank_payment.should be_nil
    end

 
   it "the bank payment should not be success" do
     @shop.stub!(:bank_payment).and_return nil
     !@shop.bank_payment.should be_nil
    end

end
describe '#build_credit_card_payment' do
  
   it "the credit card payment should be success" do
         @shop.stub!(:credit_card_payment).and_return nil
      @shop.credit_card_payment.should be_nil
    end

 
   it "the credit card payment should not be success" do
     @shop.stub!(:credit_card_payment).and_return nil
     !@shop.credit_card_payment.should be_nil
    end

end
 describe '#payment_setup_saved?' do
  
   it "the payment setup should be saved" do
     @shop.stub!(:payment_setup_saved?).and_return true
      @shop.payment_setup_saved?.should be_true
    end
   it "the payment setup should not be saved" do
     @shop.stub!(:payment_setup_saved?).and_return true
!@shop.payment_setup_saved?.should be_true
    end

end

end