class Admin::CachedPagesController < Admin::BaseController
  helper :cached_pages
  
  before_filter :set_cached_pages, :only => :index
  before_filter :set_cached_page, :only => :destroy
  
  layout 'admin', :except => [:destroy]
  
  guards_permissions :site, :manage => [:index, :destroy, :clear]
  
  # Makes rspec happy
  def index
  end

  def destroy
    self.class.expire_page @cached_page.url
    @cached_page.destroy
    respond_to {|format| format.js }
  end
  
  def clear
    expire_site_page_cache
    
    flash[:notice] = 'The cache has been cleared.'
    redirect_to admin_cached_pages_path
  end
  
  private
    def set_cached_pages
      conditions = params[:query] ? ['url LIKE ?', ["%#{params[:query]}%"]] : nil
      @cached_pages = @site.cached_pages.paginate :page => current_page, :conditions => conditions, :include => :references
    end
    
    def set_cached_page
      @cached_page = @site.cached_pages.find params[:id]
    end
end
