module ShopHelper
  include Admin::ShopHelper

  def get_products_in_cart
    @section.products.find(session[:products_in_cart].keys.collect{|key| key.to_s.to_i})
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
  
  
end