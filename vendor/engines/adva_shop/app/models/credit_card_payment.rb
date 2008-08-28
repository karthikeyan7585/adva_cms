class CreditCardPayment < ActiveRecord::Base
  belongs_to :shop, :foreign_key => 'section_id'
  
  validates_format_of :account_email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  
  def self.payment_gateways
    [["Paypal Website Payment Pro (US)", "PaypalGateway"]]
  end
  
  def self.acceptable_credit_cards
    ["visa", "american_express", "master", "discover"]
  end
  
  def accepted_credit_cards
    accepted_cards..split(',')
  end
  
end