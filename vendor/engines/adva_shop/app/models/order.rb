class Order < ActiveRecord::Base
  
  class Jail < Safemode::Jail
    allow :section, :shipping_address, :billing_address, :paid, :cancelled, :shipped, :version, :shipping_method, :payment_method
  end
  
  acts_as_versioned
  
  has_many :order_lines
  has_many :products, :through => :order_lines
  
  belongs_to :billing_address, :foreign_key => 'billing_address_id', 
             :class_name => 'Address'
             
  belongs_to :shipping_address, :foreign_key => 'shipping_address_id', 
             :class_name => 'Address'
  
  belongs_to :shipping_method
  
  belongs_to :shop, :foreign_key => "section_id"
  
  before_create :set_default_values
  
  def receive_payment
    self.paid = true
    self.save
  end
  
  def ship_items
    self.shipped = true
    self.save
  end
  
  def cancel_order
    self.cancelled = true
    self.save
  end
  
  def total_price
    order_lines.collect{|order_line| order_line.total_price}.sum
  end
  
  def shipping_cost
    self.shipping_method.nil? ? 0 : self.shipping_method.shipping_cost
  end
  
  def total_cost
    total_price + shipping_cost
  end

  def shipping_status
    shipped? ? "Shipped" : "Not Shipped"
  end
  
  def payment_status
    paid? ? "Paid" : "Not Paid"
  end
  
  def completed?
    paid? && shipped?
  end
  
  protected
  
  def set_default_values
    self.shipped = false
    self.cancelled = false
    return self
  end
  
end