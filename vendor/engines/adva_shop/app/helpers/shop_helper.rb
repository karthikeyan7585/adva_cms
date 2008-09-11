module ShopHelper
  include Admin::ShopHelper
  
  # Returns an array of products which are added in the cart
  def get_products_in_cart
     @section.products.find(@cart.cart_items.collect{|cart_item| cart_item.product_id})
  end
  
  # Returns the select option tag for the credit card expiration year. The next 10 years will be displayed from the current year,
  # including the currect year
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
  
  # Return the select option tag for the credit card expiration month
  def month_select_for(model)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, :month, months.map { |expDateMonth| [expDateMonth, expDateMonth] })            
  end
    
  # Sets the quantity of the product in the cart
  def product_quantity(product)
    @cart_line = @cart.cart_items.select{|cart_item|cart_item.product_id == product.id}.first
    @product_quantity = @cart_line.nil? ? 1 : @cart_line.quantity 
  end
  
  # Returns the total price of the product in the cart
  def total_price(product)
    @total_price = (product.price+(product.price*product.tax_rate/100))* product_quantity(product).to_i
  end
  
end