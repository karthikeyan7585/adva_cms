class ExternalPayment < ActiveRecord::Base
  belongs_to :shop, :foreign_key => 'section_id'
  
  validates_format_of :account_email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  
  def self.payment_gateways
    [["Paypal Website Payment Standards", "PaypalGateway"]]
  end
  
end