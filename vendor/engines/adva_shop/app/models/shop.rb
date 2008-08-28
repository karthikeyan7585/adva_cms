class Shop < Section  
  has_many_comments
  has_many :products, :foreign_key => 'section_id'
  has_many :orders, :foreign_key => 'section_id'
  has_many :payment_methods, :foreign_key => 'section_id'
  has_many :shipping_methods, :foreign_key => 'section_id'  
  
  has_one :external_payment, :foreign_key => 'section_id'
  has_one :bank_payment, :foreign_key => 'section_id'
  has_one :credit_card_payment, :foreign_key => 'section_id'
  
  has_one  :recent_comment, :class_name => 'Comment', 
                            :order => "comments.created_at DESC", 
                            :foreign_key => :section_id
  
  permissions :category => { :moderator => :all },
              :product  => { :moderator => :all },
              :orders   => { :admin => :all },
              :comment  => { :anonymous => :show, :user => :create, :admin => :update, :moderator => :destroy }        
              
  def build_payments(params)
    build_external_payment(params)
    build_credit_card_payment(params)
    build_bank_payment(params)
    build_shipping_methods(params)
    self.save
    return payment_setup_saved?
  end
              
  def build_external_payment(params)
    if self.external_payment.nil?
      self.external_payment = ExternalPayment.new(params[:external_payment])
    else
      self.external_payment.update_attributes(params[:external_payment])
    end
  end
  
  def build_credit_card_payment(params)
    if self.credit_card_payment.nil?
      self.credit_card_payment = CreditCardPayment.new(params[:credit_card_payment].merge(:accepted_cards => params[:credit_cards].values.join(',')))
    else
      self.credit_card_payment.update_attributes(params[:credit_card_payment].merge(:accepted_cards => params[:credit_cards].values.join(',')))
    end
  end
  
  def build_bank_payment(params)
    if self.bank_payment.nil?
      self.bank_payment = BankPayment.new(params[:bank_payment])
    else
      self.bank_payment.update_attributes(params[:bank_payment])
    end
  end
  
  def payment_setup_saved?
    self.external_payment.errors.blank? && self.credit_card_payment.errors.blank? && self.bank_payment.errors.blank?
  end
  
  def build_shipping_methods(params)
    unless params[:shipping_method][:name].blank? and params[:shipping_method][:shipping_cost].blank?
      shipping_method = ShippingMethod.new(params[:shipping_method].merge(:section_id => self.id))
      shipping_method.save
    end
  end
 
end