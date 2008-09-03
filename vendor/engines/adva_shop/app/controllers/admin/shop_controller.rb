class Admin::ShopController < Admin::BaseController
  
  layout "admin"
  
  before_filter :set_site
  before_filter :set_section, :set_shop
  before_filter :set_payments, :only => :show
  widget :section_tree, :partial => 'widgets/admin/section_tree',
                        :only    => { :controller => ['admin/shop'] }
  
  widget :menu_section, :partial => 'widgets/admin/menu_section',
                        :only  => { :controller => ['admin/shop'] }
  
  
  def show
    
  end
  
  def save_payment_setup
    if @shop.build_payments(params)
      flash[:notice] = "The payment setup has been saved."
      redirect_to admin_shop_path(@site, @section, @section)
    else
      flash.now[:error] = "The payment setup could not be saved."
      render :action => 'show'
    end
  end
  
  protected
  
    def set_site
      @site = Site.find(params[:site_id])
    end
  
    def set_section
      @section = @site.sections.find(params[:section_id])
    end
    
    def set_shop
      @shop = @section
    end
  
    def set_payments
      @external_payment = @shop.external_payment
      @credit_card_payment = @shop.credit_card_payment
      @bank_payment = @shop.bank_payment
    end
end