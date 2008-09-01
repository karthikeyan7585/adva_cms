module Admin
  module OrdersHelper
    def order_status_options
      options = [["- All Orders -", '']]
      Order::STATUS.each do |key, val|
        options << [key.to_s.humanize, val]
      end
      return options
    end
  end
end
