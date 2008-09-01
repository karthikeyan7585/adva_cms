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


  def index
    render :template => 'admin/orders/index'
  end
  
  def edit
    @order_version=OrderVersion.find(:all, :conditions => {:section_id => @section.id})
  end

  def receive_payment
    if @order.receive_payment
      Emailer.deliver_contact(@order.billing_address.email,'from adva cms')

      flash[:notice] = "Successfully updated."
      redirect_to admin_orders_path
    else
       flash.now[:error] = "The status could not be updated."
       render :action => 'edit'
    end
  end
  
  def ship_items
    if @order.ship_items
      flash[:notice] = "Successfully updated."
      redirect_to admin_orders_path
    else
       flash.now[:error] = "The status could not be updated."
       render :action => 'edit'
    end
  end
  
  def cancel_order
    if @order.cancel_order
      flash[:notice] = "The order has been cancelled."
      redirect_to admin_orders_path
    else
      flash.now[:error] = "The order could not be cancelled."
      render :action => 'edit'
    end
  end
  
  def shipping_page
    @order = @section.orders.find(params[:id])
    render :action =>'shipping_page',:layout =>false
  end
  
  private
  
  
    def set_section
      @section = @site.sections.find(params[:section_id])
    end
    
    def set_categories
      @categories = @section.categories.roots
    end
    
    def set_order
      @order = @section.orders.find(params[:id])
    end
    
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
      end
      options
    end  
    def set_orders
      conditions = "orders.status > 0 and orders.status < 3 and orders.cancelled=false"
      filt_options = filter_options[:conditions]
      conditions = conditions + " and " + filt_options if filt_options
      options = {:page => current_page, :per_page => 10, :order => "orders.id", :conditions => [conditions]}
      @orders = @section.orders.paginate options
    end
    
end