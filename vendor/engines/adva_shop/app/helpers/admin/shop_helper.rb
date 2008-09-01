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
    
  end
end