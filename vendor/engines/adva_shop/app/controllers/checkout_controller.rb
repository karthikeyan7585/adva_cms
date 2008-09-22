class CheckoutController < BaseController  

  prepend_before_filter :find_order, :only => [:add_billing_details]
  prepend_before_filter :set_order, :only => [:proceed_to_payment, :process_payment, :confirm_external_payment, :complete_external_payment,:add_billing_details]
  
  prepend_before_filter :set_section
  
  before_filter :set_addresses, :only => [:add_billing_details, :proceed_to_payment]
  before_filter :set_billing_address, :set_shipping_address, :only => [:proceed_to_payment]
  
  authenticates_anonymous_user
  
  def add_billing_details
    
  end
  
  #Save the billing and shipping details and proceed to the payment screen
  def proceed_to_payment
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
  
  # Process the payment with the payment method selected by the user
  def process_payment  
    if params[:payment_method] == "CreditCardPayment"
      # Process the payment with the credit card information of the user
      success = @section.credit_card_payment.process(params, @order, request)
      render :action => 'error' unless success
      
      # Send the confirmation mail if the payment is successful
      send_order_confirmation_mail if success
      session[:order_id] = nil
    elsif params[:payment_method] == "ExternalPayment"
      # Create a gateway for the external payment
      gateway = @section.external_payment.create_gateway
      # Setup the purchase information
      setup_response = gateway.setup_purchase(@order.total_price * 100,
                          :ip                => request.remote_ip,
                          :return_url        => confirm_external_payment_url(@section, @order),
                          :cancel_return_url => shop_url(@section)#,
                          )                    
      redirect_to gateway.redirect_url_for(setup_response.token)
    elsif params[:payment_method] == "BankPayment"
      @order.payment_method = params[:payment_method]
      @order.status = Order::STATUS[:new]
      # Save the order and send the confirmation email to the user
      send_order_confirmation_mail if @order.save
      session[:order_id] = nil
    end
  end
  
  # Get the user details from the external payment service and display the details to the user
  # to confirm the payment
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
  
  # Complete the external payment
  def complete_external_payment
    # Process the external payment with the order information
    success = @section.external_payment.process(params, @order, request)
    if success
      # Send the confirmation mail to the user if the order is successful
      send_order_confirmation_mail
      render :action => 'process_payment'
    else
      render :action => 'error'
    end
    session[:order_id] = nil
  end
  
  def remove_address
    Address.destroy(params[:address_id])
    redirect_to add_billing_details_path
  end
  
  private
  
    def set_section
      @section = Section.find(params[:section_id])
    end
    
    def set_order
      @order = Order.find(session[:order_id]) unless session[:order_id].blank?
    end
    
    def find_order
       unless session[:order_id] 
          @order = Order.new
          @order.shop = @section
          @order.order_lines = Cart.find(session[:cart_id]).cart_items.collect{|item| OrderLine.new(:product_id => item.product_id, :quantity => item.quantity )}
          Cart.destroy(session[:cart_id]) if @order.save
          session[:cart_id] = nil
          session[:order_id] = @order.id unless @order.new_record?
       end
    end
    
    def set_addresses
      @addresses = current_user.is_a?(User) ? current_user.addresses : []
    end
    
    # Set the billing address
    def set_billing_address
      if params[:selected_billing_address].blank? or params[:selected_billing_address] == "new"
        if current_user.is_a?(Anonymous)
          # Create a new billing address for the anonymous user
          @billing_address = Address.new(params[:billing_address].merge(:email => params[:email]))
        else
          # Create a new billing address for the registered user
          @billing_address = current_user.addresses.build(params[:billing_address].merge(:email => params[:email]))
        end
      else
        # Select the existing address as the billing address if the registered user selects one of his addresses
        @billing_address = current_user.addresses.find(params[:selected_billing_address].to_i)
      end
    end
    
    # Set the shipping address for the order
    def set_shipping_address
      if params[:ship_to_billing_address]
        # Set the shipping address to billing address
        @shipping_address = @billing_address
      else
        if params[:selected_billing_address].blank? or params[:selected_shipping_address] == "new"
          if current_user.is_a?(Anonymous)
            # Create a new shipping address for the anonymous user
            @shipping_address = Address.new(params[:shipping_address].merge(:email => params[:email]))
          else
            # Add a address for the registered user
            @shipping_address = current_user.addresses.build(params[:shipping_address].merge(:email => params[:email]))
          end
        else
          # Select the existing address as the shipping address if the registered user selects one of his addresses
          @shipping_address = current_user.addresses.find(params[:selected_shipping_address].to_i)
        end
      end
    end
    
    def send_order_confirmation_mail
      ShopMailer.deliver_order_confirmation @order, confirmation_url
    end
    
    def confirmation_url
      process_payment_url(@section, @order)
    end  
end