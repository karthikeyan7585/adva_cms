class PaymentMethod < ActiveRecord::Base
  belongs_to :shop
  
  validates_presence_of :payment_type, :section_id
  
  serialize :payment_attributes  
    
  def self.inheritance_column
    'payment_type'
  end
  
  def process(params, order, request, response, options = {})
    nil
  end
  
  protected
  
  def validate
    self.payment_attributes.each do |key, value|
      self.errors.add(key.to_s, "can't be blank") if value.blank?
    end
    return self.errors.blank?
  end   
  
  def create_gateway
    config = YAML::load(File.open("#{RAILS_ROOT}/vendor/engines/adva_shop/config/paypal/config.yml"))
    self.payment_gateway.constantize.new(:login => config['account']['login'], :password => config['account']['password'], :signature =>config['account']['signature'])
  end
end

class ExternalPayment < PaymentMethod
  def self.payment_gateways
    [["PayPal Express Checkout", "ActiveMerchant::Billing::PaypalExpressGateway"]]
  end
  
  def payment_gateway
    payment_attributes[:payment_gateway]
  end
  
  def account_email
    payment_attributes[:account_email]
  end
  
  #DEVNOTE - Remove the response parameter
  def process(params, order, request, response)
    amount =  order.total_price * 100
    
    gateway = self.create_gateway
    
    #DEVNOTE - Rename this as result
    purchase = gateway.purchase(amount,
                                :ip       => request.remote_ip,
                                :payer_id => params[:payer_id],
                                :token    => params[:token]
    )
    
    purchase = gateway.transfer(amount, self.account_email) if purchase.success?

    if purchase.success?
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
  
  def payment_gateway
    payment_attributes[:payment_gateway]
  end
  
  def account_email
    payment_attributes[:account_email]
  end
  
  def accepted_credit_cards
    payment_attributes[:accepted_cards].keys
  end
  
  def process(params, order, request, response)
    credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
     
    if credit_card.valid?
      # Convert dollars into cents
      amount =  order.total_price * 100
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
        gateway.capture(amount, response.authorization)
        gateway.transfer(amount, self.account_email)
        order.status = Order::STATUS[:paid]
        #DEVNOTE - This should not be saved now. This should be saved before processing. You should call order.payment_method.procss unless process_method.is_a (BankPayment)
        order.payment_method = "CreditCardPayment"
        order.save
        return true
      else         
        return false
      end
    else
      #DEVNOTE - Throw the exception and capture it in the controller. do something there
      return "Credit card is invalid"
    end
  end
end

class BankPayment < PaymentMethod
  has_one :address, :as => :addressable
  
  def bank_code
    payment_attributes[:bank_code]
  end
  
  def iban_number
    payment_attributes[:iban_number]
  end
  
  def swift_code
    payment_attributes[:swift_code]
  end
end

