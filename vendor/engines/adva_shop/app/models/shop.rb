class Shop < Section  

  has_many :products, :foreign_key => 'section_id'
  has_many :orders, :foreign_key => 'section_id'
  
  has_one :external_payment, :foreign_key => 'section_id', :class_name => 'PaymentMethod::ExternalPayment'
  has_one :bank_payment, :foreign_key => 'section_id', :class_name => 'PaymentMethod::BankPayment'
  has_one :credit_card_payment, :foreign_key => 'section_id', :class_name => 'PaymentMethod::CreditCardPayment'
  
  has_one  :recent_comment, :class_name => 'Comment', 
                            :order => "comments.created_at DESC", 
                            :foreign_key => :section_id
  
  permissions :category => { :admin => :all },
              :product  => { :admin => :all },
              :orders   => { :admin => :all },
              :comment  => { :anonymous => :show, :author => :create, :user => :update, :moderator => :destroy }  
              
  # Returns an array of the payment methods which are already selected for the shop
  def selected_payment_methods
    sel_payment_methods = []
    sel_payment_methods << self.external_payment.payment_type.to_s if self.external_payment
    sel_payment_methods << self.credit_card_payment.payment_type.to_s if self.credit_card_payment
    sel_payment_methods << self.bank_payment.payment_type.to_s if self.bank_payment
    return sel_payment_methods
  end

  # Builds the selected payment methods and saves the setup
  def build_payments(params)
    params[:external_payment_method] ? build_external_payment(params) : (self.external_payment.destroy if self.external_payment)
    params[:credit_card_payment_method] ? build_credit_card_payment(params) : (self.credit_card_payment.destroy if self.credit_card_payment)
    params[:bank_payment_method] ? build_bank_payment(params): (self.bank_payment.destroy if self.bank_payment)
    return self.save
  end
              
  # Builds the external payment details for the shop              
  def build_external_payment(params)
    if self.external_payment.nil?
      self.external_payment = PaymentMethod::ExternalPayment.new(params[:external_payment])
    else
      self.external_payment.update_attributes(params[:external_payment])
    end
  end
  
  # Builds the credit card payment details for the shop
  def build_credit_card_payment(params)
    if self.credit_card_payment.nil?
      self.credit_card_payment = PaymentMethod::CreditCardPayment.new(params[:credit_card_payment])
    else
      self.credit_card_payment.update_attributes(params[:credit_card_payment])
    end
  end
  
  # Builds the bank payment details for the shop
  def build_bank_payment(params)
    if self.bank_payment.nil?
      bank_payment_address = Address.new(params[:bank_payment].delete(:address))
      self.bank_payment = PaymentMethod::BankPayment.new(params[:bank_payment])
      self.bank_payment.address = bank_payment_address
    else
      if self.bank_payment.address.nil?
        self.bank_payment.address = Address.new(params[:bank_payment].delete(:address)) 
        self.bank_payment.address.save
      else
        self.bank_payment.address.update_attributes(params[:bank_payment].delete(:address)) 
      end
      self.bank_payment.update_attributes(params[:bank_payment])
    end
  end

  # Returns true if the shop has more than one payment methods. Otherwise returns false
  def has_payment_method?
    external_payment or credit_card_payment or bank_payment
  end
  
  # Returns true if the shop has only external payment. Otherwise returns false
  def has_only_external_payment?
    external_payment and credit_card_payment.nil? and bank_payment.nil?
  end
  
  # Returns true if the shop has only bank payment. Otherwise returns false
  def has_only_bank_payment?
    bank_payment and external_payment.nil? and credit_card_payment.nil?
  end
  
  # Returns true if the shop has credit cart payment or bank payment or both but not external payment. Otherwise returns false
  def has_no_external_payment_but_others?
    (bank_payment or credit_card_payment) and external_payment.nil?
  end
  
  # Returns true if the shop has external payment but it does not have credit card payment. Otherwise returns false
  def has_external_but_no_credit_card_payment?
    external_payment and credit_card_payment.nil?
  end
end