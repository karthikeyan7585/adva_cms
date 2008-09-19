class CartsController < BaseController
  
  before_filter :set_section
  before_filter :set_product, :only => [:show, :create, :update]
  before_filter :find_cart
  before_filter :set_cart_item , :only =>[:create, :update, :destroy]
 
  authenticates_anonymous_user
  
  def show
  end
  
  #Action to add a product to a cart
  def create
    @cart.cart_items ||= []
    if @cart_item.blank?
      @cart.cart_items << CartItem.create(:product=>@product,:quantity=> params["product_quantity_#{params[:product_id]}".to_sym].to_i)
    else
      @cart_item.update_attribute(:quantity,params["product_quantity_#{params[:product_id]}".to_sym].to_i)
    end
    redirect_to shop_path(@section)
  end
  
  def update
    quantity = params["product_quantity_#{params[:product_id]}".to_sym].to_i

    if quantity > 0
      @cart_item.update_attribute(:quantity , quantity)
    else 
      @cart_item.destroy 
    end
    
    redirect_to cart_path(@section, @cart)
  end
  
  def destroy
    @cart_item.destroy
    redirect_to cart_path(@section, @cart)
  end
  

  private
  
  #Action to return a product based on the product_id
  def set_product
    @product = @section.products.find_by_permalink params[:permalink] unless params[:permalink].blank?
    @product ||= @section.products.find_by_id params[:product_id]
  end
  
  #Action to return the section based on the section_id
  def set_section
    super Shop
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
end