module CheckoutHelper
  include ShopHelper
  
  def shipping_address_form_selected(params)
    if params[:billing_address]
      if params[:ship_to_billing_address].blank?
        return false
      else
        return true
      end
    else 
      return true
    end
  end
end