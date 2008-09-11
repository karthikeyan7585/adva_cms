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
  
  # Set the order status as paid and save the order
  def receive_payment
    self.status = Order::STATUS[:paid]
    self.save
  end

  # Set the order status as shipped and save the order
  def ship_items
    self.status = Order::STATUS[:shipped]
    self.save
  end

  # Set the order status as cancelled and save the order
  def cancel_order
    self.status = Order::STATUS[:cancelled]
    self.save
  end
  
  # Returns the total price of the order
  def total_price
    order_lines.collect{|order_line| order_line.total_price}.sum
  end
  
  # Returns "Shipped" if the order items are shipped. Else returns "Not Shipped".
  def shipping_status
    shipped? ? "Shipped" : "Not Shipped"
  end
  
  # Returns "Paid" if the payment has been received for the selected order. Else returns "Not Paid".
  def payment_status
    paid?  ? "Paid" : "Not Paid"
  end
  
  # Returns whether the order has been completed or not. If the order is paid and shipped, then the order is completed, 
  # otherwise the order is not completed.
  def completed?
    shipped?
  end
  
  # Returns whether the order items have been shipped or not
  def shipped?
    status == 3
  end
  
  # Returns whether the order is paid or not
  def paid?
    status > 1 and status < 4
  end
  
  # Returns whether the order has been cancelled or not
  def cancelled?
    status == 4
  end
  
  
  protected
  
  # Save the billing address and shipping address if the user has selected a new address for billing/shipping
  def save_addresses
    self.billing_address.save if !self.billing_address.nil? and self.billing_address.new_record?
    self.shipping_address.save if !self.shipping_address.nil? and self.shipping_address.new_record?    
  end
  
  # Set order status as INCOMPLETE when the user checks out the order
  def set_default_values
    self.status = Order::STATUS[:incomplete] if self.status.blank?
    return self
  end
  
end