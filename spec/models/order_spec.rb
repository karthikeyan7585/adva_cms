require File.dirname(__FILE__) + '/../spec_helper'

describe Order do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
    scenario :shop_orders
    
    @time_now = Time.zone.now
    Time.stub!(:now).and_return(@time_now)
    
    @order = Order.new :created_at => @time_now

end
describe '#recive_payment?' do
  
   it "the payment should be recived" do
     @order.stub!(:paid?).and_return true
     @order.should_not_receive(:paid).any_number_of_times.and_return(0)
    end
       it "the payment should not be recived" do
          @order.stub!(:paid?).and_return false
        @order.should_receive(:paid).any_number_of_times.and_return(1)
      end
  end 
  
 describe '#ship_items?' do
  
   it "the order should be shipped" do
      @order.stub!(:shipped?).and_return true
 @order.ship_items.should be_true
    end
       it "the order should not be recived" do
          @order.stub!(:shipped?).and_return false
 !@order.ship_items.should be_true
      end
  end 


 describe '#cancel_order?' do
  
   it "the order should be cancelled" do
     @order.stub!(:cancelled?).and_return true
@order.cancel_order.should be_true
    end
       it "the order should not be cancelled" do
          @order.stub!(:cancelled?).and_return false
!@order.cancel_order.should be_true
      end
  end 
   describe '#shipping_status?' do
  
   it "the status should be Shipped" do
     @order.stub!(:shipped?).and_return true
@order.shipping_status.should =='Shipped'
    end
       it "the order should not be cancelled" do
          @order.stub!(:cancelled?).and_return false
!@order.shipping_status.should =='Shipped'
      end
  end 
  
   describe '#compelted?' do
  
   it "the order should be Completed" do
     @order.stub!(:shipped?).and_return true
     @order.stub!(:paid?).and_return true
@order.completed?.should be_true
    end
       it "the order should not be Paid" do
     @order.stub!(:shipped?).and_return false
     @order.stub!(:paid?).and_return false
!@order.completed?.should be_true
end

  end 
  
end