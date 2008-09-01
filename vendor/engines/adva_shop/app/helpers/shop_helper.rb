module ShopHelper
  include Admin::ShopHelper
  
  def get_products_in_cart
     @section.products.find(@cart.cart_items.collect{|cart_item| cart_item.product_id})
  end
  
  def shipping_method_options
    @section.shipping_methods.collect{|ship_method| [ship_method.name, ship_method.id]}
  end
  
   def year_select_for(model)
    years = []
    year = Date.today.year
    count = 1
    while count <= 10
        years << year
        year = year + 1
        count = count + 1
    end    
    select(model, :year, years.map { |expDateYear| [expDateYear, expDateYear] })            
  end
  
  def month_select_for(model)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, :month, months.map { |expDateMonth| [expDateMonth, expDateMonth] })            
  end
    
  def product_quantity(product)
    @cart_line = @cart.cart_items.select{|cart_item|cart_item.product_id == product.id}.first
    @product_quantity = @cart_line.nil? ? 1 : @cart_line.quantity 
  end
  
  def total_price(product)
    @total_price = (product.price+(product.price*product.tax_rate/100))* product_quantity(product).to_i
  end
  
end