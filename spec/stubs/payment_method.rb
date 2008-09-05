define PaymentMethod do
  belongs_to :shop
end

define ExternalPayment do
  belongs_to :shop
  
  methods   :id => 1,
            :section_id => 1,
            :payment_attributes => {:account_email => 'ratnav_1216101869_biz@gmail.com',
                                    :payment_gateway => 'ActiveMerchant::Billing::PaypalExpressGateway'}
end

define CreditCardPayment do
  belongs_to :shop
  
  methods   :id => 1,
            :section_id => 1,
            :payment_attributes => {:account_email => 'ratnav_1216101869_biz@gmail.com',
                                    :payment_gateway => 'ActiveMerchant::Billing::PaypalExpressGateway',
                                    :accepted_cards => { :master => "1", :visa => "1", :discover => "1"}}
end

define BankPayment do
  belongs_to :shop
  
  methods   :id => 1,
            :section_id => 1,
            :payment_attributes => {:iban_number => '1234', :swift_code => 'SW123', :bank_code => '321'}
end