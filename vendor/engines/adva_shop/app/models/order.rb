class Order < ActiveRecord::Base
  
  class Jail < Safemode::Jail
    allow :section, :shipping_address, :billing_address, :paid, :cancelled, :shipped, :version, :payment_method, :session
  end
  
  acts_as_versioned
  
  has_many :order_lines
  has_many :order_versions
  has_many :products, :through => :order_lines
  
  belongs_to :billing_address, :foreign_key => 'billing_address_id', 
             :class_name => 'Address'
             
  belongs_to :shipping_address, :foreign_key => 'shipping_address_id', 
             :class_name => 'Address'
  
  belongs_to :shop, :foreign_key => "section_id"
  
  before_create :set_default_values
  #DEVNOTE - Think of saving the address when you actually need it
  before_save   :save_addresses
  
  STATUS = {:incomplete => 0, :new => 1, :paid => 2, :shipped => 3}
  
  def receive_payment
    self.status = Order::STATUS[:paid]
    self.save
  end
  
  def ship_items
    self.status = Order::STATUS[:shipped]
    self.save
  end
  
  #DEVNOTE - cancel can come in status
  def cancel_order
    self.cancelled = true
    self.save
  end
  
  def total_price
    order_lines.collect{|order_line| order_line.total_price}.sum
  end
  
  #DEVNOTE - Why we have two different methods total_cost and total_price
  def total_cost
    total_price
  end
  
  #DEVNOTE - Remove this method
  def shipping_status
    status > 2 ? "Shipped" : "Not Shipped"
  end
  
  #DEVNOTE - Remove this method
  def payment_status
    status > 1  ? "Paid" : "Not Paid"
  end
  
  #DEVNOTE - Update this method
  def completed?
    status > 2
  end
  
  #DEVNOTE - Update this method
  def shipped?
    status > 2
  end
  
  #DEVNOTE - Update this method
  def paid?
    status > 1
  end
  
  
  protected
  
  def save_addresses
    self.shipping_address.save if !self.shipping_address.nil? and self.shipping_address.new_record?
    self.shipping_address.save if !self.shipping_address.nil? and self.shipping_address.new_record?    
  end
  
  def set_default_values
    self.status = Order::STATUS[:incomplete] if self.status.blank?
    self.cancelled = false if self.cancelled.blank?
    return self
  end
  
end