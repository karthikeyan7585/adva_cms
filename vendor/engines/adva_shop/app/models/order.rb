class Order < ActiveRecord::Base
  
  class Jail < Safemode::Jail
    allow :section, :shipping_address, :billing_address, :status, :version, :payment_method
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
  
  before_save   :save_addresses
  
  STATUS = {:incomplete => 0, :new => 1, :paid => 2, :shipped => 3, :cancelled => 4}
  
  def receive_payment
    self.status = Order::STATUS[:paid]
    self.save
  end
  
  def ship_items
    self.status = Order::STATUS[:shipped]
    self.save
  end
  
  def cancel_order
    self.status = Order::STATUS[:cancelled]
    self.save
  end
  
  def total_price
    order_lines.collect{|order_line| order_line.total_price}.sum
  end
  
  def shipping_status
    shipped? ? "Shipped" : "Not Shipped"
  end
  
  def payment_status
    paid?  ? "Paid" : "Not Paid"
  end
  
  def completed?
    shipped?
  end
  
  def shipped?
    status == 3
  end
  
  def paid?
    status > 1 and status < 4
  end
  
  def cancelled?
    status == 4
  end
  
  
  protected
  
  def save_addresses
    self.shipping_address.save if !self.shipping_address.nil? and self.shipping_address.new_record?
    self.shipping_address.save if !self.shipping_address.nil? and self.shipping_address.new_record?    
  end
  
  def set_default_values
    self.status = Order::STATUS[:incomplete] if self.status.blank?
    return self
  end
  
end