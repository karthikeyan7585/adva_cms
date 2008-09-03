class CheckoutController < BaseController  

  #DEVNOTE - You need to remove the following two lines and you need only the find_order
  prepend_before_filter :create_order, :only => [:add_billing_details]
  prepend_before_filter :set_order, :only => [:proceed_to_payment, :process_payment, :confirm_external_payment, :complete_external_payment]
  
  prepend_before_filter :set_section
  
  before_filter :set_addresses, :only => [:add_billing_details, :proceed_to_payment]
  before_filter :set_billing_address, :set_shipping_address, :only => [:proceed_to_payment]
  
  authenticates_anonymous_user
  
  def add_billing_details
    
  end
  
  #Save the billing and shipping details and proceed to the payment screen
  def proceed_to_payment   
    #DEVNOTE - Update this logic
    if @billing_address.valid?
      @order.billing_address = @billing_address
      if @shipping_address.valid?
        @order.shipping_address = @shipping_address
        @order.save
        flash[:notice] = "Address has been added successfully."
      else
        flash.now[:error] = @shipping_address.errors.full_messages.first + " for shipping address"
        render :action => 'add_billing_details'
      end
    else
      flash.now[:error] = @billing_address.errors.full_messages.first + " for billing address"
      render :action => 'add_billing_details'
    end
  end
  
  #DEVNOTE - Add the comment
  def process_payment  
    if params[:payment_method] == "CreditCardPayment"
      success = @section.credit_card_payment.process(params, @order, request, response)
      render :action => 'error' unless success
    elsif params[:payment_method] == "ExternalPayment"
      #DEVNOTE - Add the comment
      @order.payment_method = params[:payment_method]
      gateway = @section.external_payment.create_gateway
      setup_response = gateway.setup_purchase(@order.total_price * 100,
                          :ip                => request.remote_ip,
                          :return_url        => confirm_external_payment_url(@section, @order),
                          :cancel_return_url => shop_url(@section)#,
                          )
      redirect_to gateway.redirect_url_for(setup_response.token)
    elsif params[:payment_method] == "BankPayment"
      @order.payment_method = params[:payment_method]
      @order.status = Order::STATUS[:new]
      @order.save
    end
  end
  
  def confirm_external_payment
    redirect_to shop_url(@section) unless params[:token]
    details_response = @section.external_payment.create_gateway.details_for(params[:token])
    
    unless details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end
    @address = details_response.address
  end
  
  def complete_external_payment
    success = @section.external_payment.process(params, @order, request, response)
    if success
      render :action => 'process_payment'
    else
      render :action => 'error'
    end
  end
  
  
  private
  
    def set_section
      @section = Section.find(params[:section_id])
    end
    
    def set_order
      @order = Order.find(params[:order_id])
    end
    
    #DEVNOTE - Rename this as find_order
    def create_order
      @order = Order.new
      @order.shop = @section
      @order.order_lines = Cart.find(session[:cart_id]).cart_items.collect{|item| OrderLine.new(:product_id => item.product_id, :quantity => item.quantity )}
      Cart.destroy(session[:cart_id]) if @order.save
      session[:cart_id] = nil
    end
    
    def set_addresses
      @addresses = current_user.is_a?(User) ? current_user.addresses : []
    end
    
    #DEVNOTE - Add the comments for this method
    def set_billing_address
      if params[:selected_billing_address].blank? or params[:selected_billing_address] == "new"
        if current_user.is_a?(Anonymous)
          @billing_address = Address.new(params[:billing_address].merge(:email => params[:email]))
        else
          @billing_address = current_user.addresses.build(params[:billing_address].merge(:email => params[:email]))
        end
      else
        @billing_address = current_user.addresses.find(params[:selected_billing_address].to_i)
      end
    end
    
    #DEVNOTE - Add the comments for this method
    def set_shipping_address
      if @billing_address.valid?
        if params[:ship_to_billing_address]
          @shipping_address = @billing_address
        else
          if params[:selected_billing_address].blank? or params[:selected_shipping_address] == "new"
            if current_user.is_a?(Anonymous)
              @billing_address = Address.new(params[:billing_address].merge(:email => params[:email]))
            else
              @shipping_address = current_user.addresses.build(params[:shipping_address].merge(:email => params[:email]))
            end
          else
            @shipping_address = current_user.addresses.find(params[:selected_shipping_address].to_i)
          end
        end
      end
    end
end