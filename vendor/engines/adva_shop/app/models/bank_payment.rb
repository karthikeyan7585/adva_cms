class BankPayment < ActiveRecord::Base
  belongs_to :shop, :foreign_key => 'section_id'
  
  validates_presence_of :bank_name, :account_number
end