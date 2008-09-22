class Admin::OrdersController < Admin::BaseController
  layout "admin"
  helper :assets
  
  before_filter :set_section
  before_filter :set_categories,   :only => [:new, :edit]
  before_filter :set_order, :only => [:edit, :receive_payment, :ship_items, :cancel_order]
  before_filter :set_orders, :only => :index
  
  widget :section_tree, :partial => 'widgets/admin/section_tree',
                        :only    => { :controller => ['admin/orders'] }
  
  widget :menu_section, :partial => 'widgets/admin/menu_section',
                        :only  => { :controller => ['admin/orders'] }


  # Display the shop orders which are not completed
  def index
    render :template => 'admin/orders/index'
  end
  
  # Find the selected order and render the edit page
  def edit
    # Find the order versions to show the history of the order
    @order_versions = @order.order_versions.find_coinciding_grouped_by_dates(Time.zone.now.to_date, 1.day.ago)
  end
  
  # Receive the payment and mark the status as paid
  def receive_payment
    if @order.receive_payment
      # Send the payment confirmation email to the customer if the payment is received successfully
      ShopMailer.deliver_payment_confirmation @order, confirmation_url
      flash[:notice] = "Successfully updated."
      redirect_to admin_orders_path
    else
       flash.now[:error] = "The status could not be updated."
       render :action => 'edit'
    end
  end
  
  # Ship the order items and mark the status as shipped
  def ship_items
    if @order.ship_items
      # Send the shipment confirmation email to the customer if the order items are shipped
      ShopMailer.deliver_shipment_confirmation @order, confirmation_url
      flash[:notice] = "Successfully updated."
      redirect_to admin_orders_path
    else
       flash.now[:error] = "The status could not be updated."
       render :action => 'edit'
    end
  end
  
  # Cancel the order and mark the order status as cancelled
  def cancel_order
    if @order.cancel_order
      # Send the order cancellation email to the customer if the order is cancelled
      ShopMailer.deliver_order_cancellation @order, confirmation_url
      flash[:notice] = "The order has been cancelled."
      redirect_to admin_orders_path
    else
      flash.now[:error] = "The order could not be cancelled."
      render :action => 'edit'
    end
  end
  
  # Display the shipping paper page for the selected order
  def shipping_page
    @order = @section.orders.find(params[:id])
    render :action =>'shipping_page',:layout =>false
  end
  
  private
  
    # Set the section
    def set_section
      @section = @site.sections.find(params[:section_id])
    end
    
    # Set the categories
    def set_categories
      @categories = @section.categories.roots
    end
    
    # Set the order
    def set_order
      @order = @section.orders.find(params[:id])
    end
    
    # Set the filter options for filtering the orders
    def filter_options
      options = {}
      case params[:filter]
      when 'order_id'
        options[:conditions] = Order.send(:sanitize_sql, ["orders.id = ?", params[:query].to_i])
      when 'ordered_on'
        params["order"]["ordered_on(2i)"] = "0" + params["order"]["ordered_on(2i)"]
        ordered_date = params["order"]["ordered_on(1i)"] + "/" + params["order"]["ordered_on(2i)"] + "/" + params["order"]["ordered_on(3i)"]
        ordered_date = Date.parse(ordered_date)
        options[:conditions] = Order.send(:sanitize_sql, ["orders.created_at >= ? and orders.created_at < ?", ordered_date,ordered_date+1])
      when 'status'
        options[:conditions] = Order.send(:sanitize_sql, ["orders.status = ?", params[:status]]) unless params[:status].blank?
      when 'product_id'
        options[:joins] = "INNER JOIN order_lines ON orders.id = order_lines.order_id"
        options[:conditions] = Order.send(:sanitize_sql, ["order_lines.product_id = ?", params[:query].to_i])
      when 'product_name'
        options[:joins] = "INNER JOIN order_lines ON orders.id = order_lines.order_id INNER JOIN products ON products.id = order_lines.product_id"
        options[:conditions] = Order.send(:sanitize_sql, ["LOWER(products.name) LIKE ?", "%%#{params[:query].downcase}%%"])
      when 'user_id'
        options[:joins] = "INNER JOIN addresses ON orders.billing_address_id = addresses.id"
        options[:conditions] = Order.send(:sanitize_sql, ["addresses.addressable_id = ? and addresses.addressable_type = ?", params[:query].to_i, "User"])
      end
      options
    end  
    # Set the orders
    def set_orders
      conditions = "orders.status > 0 and orders.status < 3"
      
      filt_options = filter_options
      
      if params[:filter] == "status"
        conditions = filt_options[:conditions]
      else
        conditions = conditions + " and " + filt_options[:conditions] if filt_options[:conditions]
      end
            
      options = {:page => current_page, :per_page => 10, :order => "orders.id"}
      @orders = @section.orders.paginate options.reverse_merge(:joins => filt_options[:joins], :conditions => [conditions])
    end
    
    # Return the confirmation url to find the host address for the ShopMailer
    def confirmation_url
      shop_url(@section)
    end  
end