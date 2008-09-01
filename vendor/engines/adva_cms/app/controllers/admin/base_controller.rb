class Admin::BaseController < ApplicationController
  layout "admin"
  
  authentication_required
  renders_with_error_proc :below_field
  include CacheableFlash
  include Widgets
  
  before_filter :set_site, :set_locale, :set_timezone
  helper :base, :content, :comments, :users
  helper_method :admin_section_path_for
  
  attr_accessor :site
  
  widget :menu_global,   :partial => 'widgets/admin/menu_global'
                         
  widget :menu_site,     :partial => 'widgets/admin/menu_site',
                         :except  => { :controller => 'admin/sites', :action => [:index, :new] }
  
  widget :section_tree,  :partial => 'widgets/admin/section_tree',
                         :except  => { :controller => 'admin/sites', :action => [:index, :new] },
                         :only    => { :controller => ['admin/sites', 'admin/sections', 'admin/articles', 'admin/wikipages'] }

  widget :menu_section,  :partial => 'widgets/admin/menu_section',
                         :except => { :controller => ['admin/sections'], :action => [:index, :new] },
                         :only  => { :controller => ['admin/sections', 'admin/articles', 'admin/wikipages', 'admin/categories', 'admin/comments'] } 


  # TODO delegate this to the section class? or the controller, even?
  # like Admin::WikipagesController.default_route_helper
  def admin_section_path_for(section)
    case section
      when Wiki     then admin_wikipages_path section.site, section
      when Blog     then admin_articles_path section.site, section
      when Forum    then admin_section_path section.site, section
      when Shop     then admin_products_path section.site, section
      when Section  then admin_articles_path section.site, section
      # else                 admin_articles_path section.site, section
    end                                        
  end

  protected
    
    def rescue_action(exception)
      if exception.is_a? ActionController::RoleRequired
        @error = exception
        render :template => 'shared/messages/insufficient_permissions'
      else
        super
      end
    end
  
    def current_page
      @page ||= params[:page].blank? ? 1 : params[:page].to_i
    end
  
    def set_locale
      @locale = 'en' # currently only used for blog_article_url generation
    end
  
    def set_timezone
      Time.zone = @site.timezone if @site
    end
  
    def set_site
      @site = Site.find(params[:site_id])
    end
    
    def current_role_context
      @section || @site || Site.new
    end

    def page_cache_directory
      raise "@site not set" unless @site
      @site.page_cache_directory
    end
end