class OrderLine < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  validates_numericality_of :quantity
  
  def total_price
    (self.product.price + tax_amount) * self.quantity
  end
  
  def tax_amount
    self.product.price * (self.product.tax_rate/100)
  end
end