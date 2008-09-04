class ShopMailer < ActionMailer::Base
  include Login::MailConfig
  
  def order_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Order Confirmation"
    body :order => order
  end
  
  def payment_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Payment Confirmation"
    body :order => order
  end
  
  def shipment_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Shipment Confirmation"
    body :order => order
  end
  
  def order_cancellation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Order Cancellation"
    body :order => order
  end
end 