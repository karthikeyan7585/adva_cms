require File.dirname(__FILE__) + '/../spec_helper'

describe Product do
  include Stubby, Matchers::ClassExtensions
  
  before :each do
    scenario :section_with_active_product
    
    @time_now = Time.zone.now
    Time.stub!(:now).and_return(@time_now)
    
    @product = Product.new :created_at => @time_now
    @product.stub!(:new_record?).and_return(false)
    @product.stub!(:section).and_return Section.new
  end
  
  def current_month
    Time.local Time.now.year, Time.now.month, 1
  end
    
    describe '#accept_comments?' do
      it "accept comments when comments never expire" do
        @product.should_receive(:comment_age).any_number_of_times.and_return(0)
        @product.should_receive(:published_at).any_number_of_times.and_return(2.days.ago)
        @product.accept_comments?.should be_true
      end
  
      it "accept comments when comments are allowed and not expired" do
        @product.should_receive(:comment_age).any_number_of_times.and_return(3)
        @product.should_receive(:published_at).any_number_of_times.and_return(2.days.ago)
        @product.accept_comments?.should be_true 
      end
  
      it "not accept comments when comments are allowed but expired" do
        @product.should_receive(:comment_age).any_number_of_times.and_return(2)
        @product.should_receive(:published_at).any_number_of_times.and_return(3.days.ago)
        @product.accept_comments?.should be_false
      end
  
      it "not accept comments when comments are not allowed" do
        @product.should_receive(:comment_age).any_number_of_times.and_return(-1)
        @product.should_receive(:published_at).any_number_of_times.and_return(2.days.ago)
        @product.accept_comments?.should be_false
      end
  
    end
    
end