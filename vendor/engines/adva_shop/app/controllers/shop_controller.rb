class ShopController < BaseController
  
  before_filter :set_section
  before_filter :set_category, :set_tags, :only => :index
  before_filter :set_products, :only => [:index,:add_to_cart]
  before_filter :set_product, :only => [:show,:add_to_cart,:update_cart,:remove_from_cart]
  before_filter :find_cart
    
  caches_page_with_references :index, :show, :track => ['@product', '@products', '@category', {'@site' => :tag_counts, '@section' => :tag_counts}]
    
  def index  
    respond_to do |format|
      format.html { render @section.render_options }
    end
  end
  
  #temp method to display the product description
  def show
    render @section.render_options
  end
  
  def add_to_cart
    @cart.cart_items ||= []
    @cart.cart_items << CartItem.create(:product=>@product,:quantity=> params["product_quantity_#{params[:product_id]}".to_sym].to_i)
    redirect_to :action=>"index"
  end
  
  def view_cart
    #Display the cart
  end
  
  def update_cart
    quantity = params["product_quantity_#{params[:product_id]}".to_sym].to_i
    #Update the quantity when it is given, otherwise remove the cart line
    if quantity > 0
      @cart.cart_items.select{|cart_item| cart_item.product_id == params[:product_id].to_i }.first.update_attribute(:quantity , quantity)
      redirect_to view_cart_path(@section)
    else  
      redirect_to remove_from_cart_path(@section, @product)
    end
    
  end
  
  def remove_from_cart
    @cart.cart_items.select{|cart_item| cart_item.product_id == params[:product_id].to_i }.first.destroy
    redirect_to view_cart_path(@section)
  end
  
  private
  
  #To-Do - This method needs to be tested
  def set_category
    if params[:category_id]
      @category = @section.categories.find params[:category_id]
      raise ActiveRecord::RecordNotFound unless @category
    end
  end
  
  #To-Do - This method needs to be tested
  def set_tags
    if params[:tags]
      names = params[:tags].split('+')
      @tags = Tag.find(:all, :conditions => ['name IN(?)', names]).map(&:name)
      raise ActiveRecord::RecordNotFound unless @tags.size == names.size
    end
  end
  
  #To-Do - Needs to be tested based on the tag and category based search
  def set_products    
    add_to_sortable_columns('name', { :model => Product, :field => 'name', :alias => 'name' })
    add_to_sortable_columns('price', { :model => Product, :field => 'price', :alias => 'price' })
    add_to_sortable_columns('vendor', { :model => Product, :field => 'vendor', :alias => 'vendor' })
    options = {:page => current_page, :per_page => 3, :order => sortable_order('name', :model => Product, 
                                                                                        :field => 'name', 
                                                                                        :sort_direction => :desc),
      :conditions => {:active => true} }
      
    source = @category ? @category.products : @section.products
    @products = source.paginate_with_tags options
  end
  
  #To-Do - Needs to be tested
  def set_product
    @product = @section.products.find_by_permalink params[:permalink] unless params[:permalink].blank?
    @product ||= @section.products.find_by_id params[:product_id]
  end
  
  def set_section
    @section = @site.sections.find(params[:section_id])
  end
  
  def find_cart
    id = session[:cart_id]    
    unless id.blank?
      @cart = Cart.find_or_create_by_id(id)
    else
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end
  
end