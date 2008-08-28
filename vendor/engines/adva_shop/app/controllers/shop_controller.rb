class ShopController < BaseController
  include ActionController::GuardsPermissions::InstanceMethods
  
  before_filter :set_section
  before_filter :set_category, :set_tags, :only => :index
  before_filter :set_products, :only => :index
  before_filter :set_product, :only => :show
  before_filter :add_product_to_cart, :only => :index
  before_filter :set_addresses, :only => [:select_addresses]
  before_filter :set_order, :only => [:process_payment, :complete_payment]
  
  caches_page_with_references :index, :show, :track => ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
  
  authenticates_anonymous_user
  acts_as_commentable
  
  helper_method :get_order_lines_from_session
  
  def index
    respond_to do |format|
      format.html { render @section.render_options }
    end
  end
  
  def show
    render @section.render_options
  end
  
  def view_cart

  end
  
  def update_cart
    if params["product_quantity_#{params[:product_id]}".to_sym].to_i > 0
      session[:products_in_cart][params[:product_id].to_sym] = params["product_quantity_#{params[:product_id]}".to_sym]
      redirect_to view_cart_path
    else
      redirect_to remove_from_cart_path(:product_id => params[:product_id])
    end
  end
  
  def remove_from_cart
    session[:products_in_cart].delete(params[:product_id].to_sym)
    redirect_to view_cart_path
  end
  
  def proceed_to_payment
    if params[:selected_billing_address].nil? or params[:selected_billing_address] == 'new'
      params[:billing_address] = params[:billing_address].merge(:user_id => current_user.id, :email => params[:email]) if current_user.is_a?(User)
      session[:billing_address] = Address.new(params[:billing_address])
    else
      session[:billing_address] = Address.find(params[:selected_billing_address].to_i)
    end
    
    if params[:ship_to_billing_address]
      if session[:billing_address]
        session[:shipping_address] = session[:billing_address]
      else
        params[:billing_address] = params[:billing_address].merge(:user_id => current_user.id, :email => params[:email]) if current_user.is_a?(User)
        session[:shipping_address] = Address.new(params[:billing_address])
      end
    else
      if params[:selected_shipping_address] and params[:selected_shipping_address] == 'new'
        params[:shipping_address] = params[:shipping_address].merge(:user_id => current_user.id, :email => params[:email]) if current_user.is_a?(User)
        session[:shipping_address] = Address.new(params[:shipping_address])
      else
        session[:shipping_address] = Address.find(params[:selected_shipping_address].to_i)
      end
    end
  end
  
  def select_addresses
  end
  
  def process_payment
    
    # Convert dollars into cents
    amount =  @order.total_price * 100
    
    @order.payment_method = params[:payment_method]
    @order.shipping_method_id = params[:shipping_method_id].to_i
    
    
    if params[:payment_method] == "CreditCardPayment"
     credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
     
      if credit_card.valid?
        options ={}
        options[:billing_address] = {}
        
        options[:ip] =  request.remote_ip#'124.30.96.195'
        options[:email]= session[:billing_address].email
        options[:billing_address].merge(:address1 => session[:billing_address].street1, :city => session[:billing_address].city,
                                        :state => session[:billing_address].state, :country => 'US',
                                        :zip => session[:billing_address].zip_code, :phone => session[:billing_address].phone)
        
        response = gateway.authorize(amount, credit_card, options)

        if response.success? 
          gateway.capture(amount, response.authorization)
          gateway.transfer(amount, @section.credit_card_payment.account_email)
          @order.paid = true
          save_order
        else         
          raise StandardError, response.message
        end
        clear_session
      end
    elsif params[:payment_method] == "BankPayment"
      @order.paid = false
      save_order
      clear_session
    else

      setup_response = express_gateway.setup_purchase(amount,
                :ip                => request.remote_ip,
                :return_url        => confirm_payment_url(@section),
                :cancel_return_url => shop_url(@section)#,
                )
      redirect_to express_gateway.redirect_url_for(setup_response.token)
    end
  end
  
  def confirm_payment
    
    redirect_to shop_url(@section) unless params[:token]
    
    details_response = express_gateway.details_for(params[:token])
    
    unless details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end
    
    @address = details_response.address
  end
  
  def complete_payment
    # Convert dollars into cents and then authorize
    amount =  @order.total_price * 100
    
    purchase = express_gateway.purchase(amount,
                                :ip       => request.remote_ip,
                                :payer_id => params[:payer_id],
                                :token    => params[:token]
    )
    
    purchase = express_gateway.transfer(amount, @section.credit_card_payment.account_email)

    if purchase.success?
      @order.paid = true
      save_order
    else
      @message = purchase.message
      render :action => 'error'
      return
    end
    
    render :action => 'process_payment'
  end
  
  def get_order_lines_from_session
    order_lines = []
    session[:products_in_cart].each do |prod_id, quantity|
      order_lines << OrderLine.new(:product_id => prod_id.to_s.to_i, :quantity => quantity.to_i)
    end
    return order_lines
  end
  
  private
  
  def set_category
    if params[:category_id]
      @category = @section.categories.find params[:category_id]
      raise ActiveRecord::RecordNotFound unless @category
    end
  end
  
  def set_tags
    if params[:tags]
      names = params[:tags].split('+')
      @tags = Tag.find(:all, :conditions => ['name IN(?)', names]).map(&:name)
      raise ActiveRecord::RecordNotFound unless @tags.size == names.size
    end
  end
  
  def set_products
    options = { :page => current_page, :tags => @tags, :limit => 5, :per_page => 3, 
      :order => "#{params[:sort_field] || "name"} #{params[:sort_order]}",
      :conditions => {:active => true} }
      
    source = @category ? @category.products : @section.products
    @products = source.paginate_with_tags options
  end
  
  def set_product
    @product = @section.products.find_by_permalink params[:permalink]
  end
  
  def add_product_to_cart
    if params[:product_id] and params["product_quantity_#{params[:product_id]}".to_sym].to_i > 0
      if session[:products_in_cart]
        session[:products_in_cart] = session[:products_in_cart].merge(params[:product_id].to_sym => params["product_quantity_#{params[:product_id]}".to_sym])
      else
        session[:products_in_cart] = {params[:product_id].to_sym => params["product_quantity_#{params[:product_id]}".to_sym]}
      end
    end
  end
  
  def set_addresses
    @addresses = current_user.is_a?(User) ? current_user.addresses : []
  end
  
  def set_section
    @section = @site.sections.find(params[:section_id])
  end
  
  def set_order
    @order = Order.new
    @order.order_lines = get_order_lines_from_session
    @order.billing_address = session[:billing_address]
    @order.shipping_address = session[:shipping_address]
    @order.shop = @section
  end
  
  def clear_session
    session[:products_in_cart] = nil
    session[:billing_address] = nil
    session[:shipping_address] = nil
  end
  
  def save_order
    @order.billing_address.save
    @order.shipping_address.save
    @order.save
  end
  
   def gateway
     config = YAML::load(File.open("#{RAILS_ROOT}/vendor/engines/adva_shop/public/paypal/config.yml"))
     @gateway = ActiveMerchant::Billing::PaypalGateway.new(:login => config['account']['login'], :password => config['account']['password'], :signature =>config['account']['signature'])
  end
 
 def express_gateway
    config = YAML::load(File.open("#{RAILS_ROOT}/vendor/engines/adva_shop/public/paypal/config.yml"))
    @express_gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(:login => config['account']['login'], :password => config['account']['password'], :signature =>config['account']['signature'])
 end
  
end