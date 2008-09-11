class ShopMailer < ActionMailer::Base
  include Login::MailConfig
  
  # Sends a mail to the owner of the order regarding the order details(Order ID etc...)
  # The confirmation link is the URL of the shop, to set the host name of the from address.
  def order_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Order Confirmation"
    body :order => order
  end
  
  # Sends a mail to the owner of the order when the payment has been received by the shop owner.
  # The confirmation link is the URL of the shop, to set the host name of the from address.  
  def payment_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Payment Confirmation"
    body :order => order
  end
  
  # Sends a mail to the owner of the order when the order items are shipped.
  # The confirmation link is the URL of the shop, to set the host name of the from address.  
  def shipment_confirmation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Shipment Confirmation"
    body :order => order
  end

  # Sends a mail to the owner of the order when the order is cancelled.
  # The confirmation link is the URL of the shop, to set the host name of the from address.
  def order_cancellation(order, confirmation_link)
    recipients order.billing_address.email
    from system_email(confirmation_link)
    subject "#{subject_prefix}Order Cancellation"
    body :order => order
  end
end 