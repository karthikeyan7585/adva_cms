module Admin
  module ShopHelper
    
    # Returns the Payment Gateway options for the external payment method
    def external_payment_options
      PaymentMethod::ExternalPayment.payment_gateways
    end
    
    # Returns the Payment Gateway options for the credit card payment method
    def credit_card_payment_options
      ActiveMerchant::Billing::Gateway.implementations.uniq.collect{|imp| [imp.display_name, imp.name]}
    end
    
    # Returns the product image path of the product. If the product does not have any image,
    # then the default image path will be returned
    def image_path(product)   
      product.product_image.nil? ? "rails.png" : product.product_image.public_filename
    end
    
    # Returns the order history html content of the order history from the order versions
    def render_order_versions(order_versions, recent = false)
      unless order_versions.empty?
        html = order_versions.collect do |order_version|
          render :partial => "shop/status",
          :locals => { :order_version => order_version, :recent => recent }
        end
      else
        html = %(<li class="order_version-none shade">Nothing happening</li>)
      end
      %(<ul class="order_versions">#{html}</ul>)
    end
    
    # Returns the order status change from the order version
    def order_status(order_version)
      Order::STATUS.select{|key,val|  val == order_version.status}.flatten.first.to_s.humanize
    end
    
  end
end