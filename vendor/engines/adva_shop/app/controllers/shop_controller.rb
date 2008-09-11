class ShopController < BaseController
  
  before_filter :set_section
  before_filter :set_category, :set_tags, :only => :index
  before_filter :set_products, :only => [:index,:add_to_cart]
  before_filter :set_product, :only => [:show,:add_to_cart,:update_cart,:remove_from_cart]
  before_filter :find_cart
  before_filter :set_cart_item , :only =>[:update_cart,:remove_from_cart,:add_to_cart]
 
  caches_page_with_references :index, :show, :track => ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
  authenticates_anonymous_user
  acts_as_commentable
  
  # Action to render the page with products of perticular section and site
  def index  
    respond_to do |format|
      format.html { render @section.render_options }
    end
  end
  
  #Action to render the view cart widget
  def render_cart_info_widget
      respond_to do |format|
        format.js 
      end   
  end
  
  #Action to render the description page of a particular product
  def show   
    render @section.render_options
  end
  
  #Action to add a product to a cart
  def add_to_cart
    @cart.cart_items ||= []
    if @cart_item.blank?
      @cart.cart_items << CartItem.create(:product=>@product,:quantity=> params["product_quantity_#{params[:product_id]}".to_sym].to_i)
    else
      @cart_item.update_attribute(:quantity,params["product_quantity_#{params[:product_id]}".to_sym].to_i)
    end
    redirect_to :action=>"index"
  end
  
  #Action to view the cart 
  def view_cart
  end
  
  #Action to update the quantity of the product in the cart
  def update_cart
    quantity = params["product_quantity_#{params[:product_id]}".to_sym].to_i
    #Update the quantity when it is given, otherwise remove the cart line
    if quantity > 0
      @cart_item.update_attribute(:quantity , quantity)
      redirect_to view_cart_path(@section)
    else  
      redirect_to remove_from_cart_path(@section, @product)
    end
    
  end
  
  #Action to remove the cartitem from cart
  def remove_from_cart
    @cart_item.destroy
    redirect_to view_cart_path(@section)
  end
  
  #Action to return products array based on the search term entered in the frontend
  def search_product
    @products = Product.paginate(:all, :page => current_page, :per_page => 3, :conditions=>"name like '#{params[:search_term]}%'")    
    render :template=> 'shop/index'
  end
  
  #Action to fetch the order status
  def fetch_order_status
   begin
     @order = @section.orders.find(params[:order_id]) 
     @order_versions = @order.order_versions.find_coinciding_grouped_by_dates(Time.zone.now.to_date, 1.day.ago)
   rescue   
     
   end

  end
  
  private
  
  #Action to return category collection
  def set_category
    if params[:category_id]
      @category = @section.categories.find params[:category_id]
      raise ActiveRecord::RecordNotFound unless @category
    end
  end
  
  #Action to return tags collection
  def set_tags
    if params[:tags]
      names = params[:tags].split('+')
      @tags = Tag.find(:all, :conditions => ['name IN(?)', names]).map(&:name)
      raise ActiveRecord::RecordNotFound unless @tags.size == names.size
    end
  end
  
  #Action to return products collection based on categories/tags/section_id or sortable column header
  def set_products    
    set_sort_params
    add_to_sortable_columns('name', { :model => Product, :field => 'name', :alias => 'name' })
    add_to_sortable_columns('price', { :model => Product, :field => 'price', :alias => 'price' })
    add_to_sortable_columns('vendor_name', { :model => Product, :field => 'vendor_name', :alias => 'vendor_name' })
    options = {:page => current_page, :per_page => 3, :order => sortable_order(@search_field, :model => Product, 
                                                                                        :field => @search_field, 
                                                                                        :sort_direction => @sort_direction),
                                                                                        :conditions => {:active => true} }

    source = @category ? @category.products : @section.products
    options = options.merge(:tags => @tags) unless @tags.nil?
    @products = source.paginate_with_tags options
  end
  
  #Action to return a product based on the product_id
  def set_product
    @product = @section.products.find_by_permalink params[:permalink] unless params[:permalink].blank?
    @product ||= @section.products.find_by_id params[:product_id]
  end
  
  #Action to return the section based on the section_id
  def set_section
    @section = @site.sections.find(params[:section_id])
  end
  
  #Action to create/return the cart object based on the availability of the session[:cart_id] params
  def find_cart
    id = session[:cart_id]    
    unless id.blank?
      @cart = Cart.find_or_create_by_id(id)
    else
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end
  
  #Action to return the cart_item object basesd on the params[:product_id]
  def set_cart_item
    @cart_item = @cart.cart_items.select{|cart_item| cart_item.product_id == params[:product_id].to_i }.first
  end
  
  #Action to set sort params based on header which needs to be sorted
  def set_sort_params
      if not params[:sortdesc].nil? 
        @search_field = params[:sortdesc].split('-').first
        @sort_direction = 'desc'
      elsif not params[:sortasc].nil?
        @search_field = params[:sortasc].split('-').first
        @sort_direction = 'asc'
      else
        @search_field = 'name'
        @sort_direction = 'asc'
    end
  end
end