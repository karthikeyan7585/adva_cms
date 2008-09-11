module Admin
  module OrdersHelper
    include Admin::ShopHelper
    
    # Return the array of order status options to display in the orders filter bar
    def order_status_options
      options = [["- All Orders -", '']]
      Order::STATUS.each do |key, val|
        options << [key.to_s.humanize, val] unless val == 0
      end
      return options
    end
  end
end
