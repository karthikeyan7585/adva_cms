class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  validates_numericality_of :quantity
  
  # Returns the total price of the order line
  def total_price
    (self.product.price + tax_amount) * self.quantity
  end
  
  # Returns the tax amount for the selected order line
  def tax_amount
    self.product.price * (self.product.tax_rate/100)
  end
end