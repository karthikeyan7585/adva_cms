module Admin
  module ShopHelper
    def external_payment_options
      PaymentMethod::ExternalPayment.payment_gateways
    end
    
    def credit_card_payment_options
      ActiveMerchant::Billing::Gateway.implementations.uniq.collect{|imp| [imp.display_name, imp.name]}
    end
    
    def image_path(product)   
      product.product_image.nil? ? "rails.png" : product.product_image.public_filename
    end
    
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
  
  def order_status(order_version)
      Order::STATUS.select{|key,val|  val == order_version.status}.flatten.first.to_s.humanize
  end
    
  end
end