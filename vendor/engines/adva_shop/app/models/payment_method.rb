class PaymentMethod < ActiveRecord::Base
  belongs_to :shop
  
  validates_presence_of :payment_type, :section_id
  
  serialize :payment_attributes  
    
  def self.inheritance_column
    'payment_type'
  end
  
  def process(params, order, request)
    nil
  end
  
  protected
  
  def validate
    self.payment_attributes.each do |key, value|
      self.errors.add(key.to_s, "can't be blank") if value.blank?
    end
    return self.errors.blank?
  end   
  
  # Create the gateway object with the api merchant login and password from the config file.
  def create_gateway
    config = YAML::load(File.open("#{RAILS_ROOT}/vendor/engines/adva_shop/config/paypal/config.yml"))
    self.payment_gateway.constantize.new(:login => config['account']['login'], :password => config['account']['password'], :signature =>config['account']['signature'])
  end
end

class ExternalPayment < PaymentMethod
  def self.payment_gateways
    [["PayPal Express Checkout", "ActiveMerchant::Billing::PaypalExpressGateway"]]
  end
  
  # Return the external payment gateway service
  def payment_gateway
    payment_attributes[:payment_gateway]
  end
  
  # Return the account email for the external payment service
  def account_email
    payment_attributes[:account_email]
  end
  
  # Process the external payment
  def process(params, order, request)
    amount =  order.total_price * 100
    
    gateway = self.create_gateway
    
    #Purchase the amount from the customer's account
    purchase = gateway.purchase(amount,
                                :ip       => request.remote_ip,
                                :payer_id => params[:payer_id],
                                :token    => params[:token]
    )
    
    # Transfer it to shop owner's account
    purchase = gateway.transfer(amount, self.account_email) if purchase.success?

    if purchase.success?
      order.payment_method = self.class.name
      order.status = Order::STATUS[:paid]
      order.save
      return true
    else
      return false
    end
  end
end

class CreditCardPayment < PaymentMethod
  def self.acceptable_credit_cards
    ["visa", "american_express", "master", "discover"]
  end
  
  # Return the gateway service credit card payment
  def payment_gateway
    payment_attributes[:payment_gateway]
  end
  
  # Return the account email for the credit card payment service
  def account_email
    payment_attributes[:account_email]
  end
  
  # Returns an array of accepted credit card names selected in the payment setup UI
  def accepted_credit_cards
    payment_attributes[:accepted_cards].keys
  end
  
  # Process the credit card payment
  def process(params, order, request)
    credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
     
    if credit_card.valid?
      # Convert dollars into cents
      amount =  order.total_price * 100
      
      # Set the user credit card details
      options ={}
      options[:ip] = request.remote_ip
      options[:billing_address] = {}
      
      options[:email]= order.billing_address.email
      options[:billing_address].merge(:address1 => order.billing_address.street1, :city => order.billing_address.city,
                                      :state => order.billing_address.state, :country => 'US',
                                      :zip => order.billing_address.zip_code, :phone => order.billing_address.phone)
      gateway = self.create_gateway
      response = gateway.authorize(amount, credit_card, options)

      if response.success?
        # Capture the amount from the customer's credit card
        gateway.capture(amount, response.authorization)
        # Transfer the amount the shop owner's account
        gateway.transfer(amount, self.account_email)
        order.status = Order::STATUS[:paid]
        order.payment_method = self.class.name
        order.save
        return true
      else         
        return false
      end
    else
      return "Credit card is invalid"
    end
  end
end

class BankPayment < PaymentMethod
  has_one :address, :as => :addressable
  
  # Return the bank code
  def bank_code
    payment_attributes[:bank_code]
  end
  
  # Return the IBAN number
  def iban_number
    payment_attributes[:iban_number]
  end
  
  # Return the swift code
  def swift_code
    payment_attributes[:swift_code]
  end
end

