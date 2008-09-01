class Admin::AssetsController < Admin::BaseController
  # member_actions.push(*%w(index new create latest search add_bucket clear_bucket edit update))
  # skip_before_filter :login_required
  # before_filter :login_required
  
  include AssetsHelper
  helper :assets
  helper_method :created_notice
  
  before_filter :set_search_params, :set_assets, :only => [:index]
  before_filter :set_format, :only => [:create]
  before_filter :set_asset, :only => [:edit, :update, :destroy]

  def index
    @recent = @assets.slice! 0, 4 if params[:source] != 'widget'
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new
    @assets = [Asset.new]
  end
  
  def create
    @assets = @site.assets.build(params[:assets].values)
    Asset.transaction { @assets.each &:save! }
    
    respond_to do |format|
      format.html do
        flash[:notice] = created_notice
        redirect_to(admin_assets_path)
      end
      format.js { responds_to_parent { render :action => 'create' } }
    end        
  rescue ActiveRecord::RecordInvalid => e
    render :action => 'new'
  end
  
  def edit
  end

  def update
    @asset.update_attributes! params[:asset]
    redirect_to admin_assets_path
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def destroy
    @asset.destroy
    redirect_to admin_assets_path
    (session[:bucket] || {}).delete(@asset.public_filename)
    flash[:notice] = "Deleted '#{@asset.filename}'"
  end

  protected
    
    def set_assets
      @types  = params[:filter].blank? ? [] : params[:filter].keys
      options = search_options.merge(:per_page => params[:limit], :page => current_page, :total_entries => count_by_conditions)
      @assets = @types.any? ? site.assets.paginate_by_content_types(@types, :all, options) : site.assets.paginate(options) 
    end
    
    def set_asset
      @asset = @site.assets.find params[:id]
    end  
    
    def set_search_params      
      params[:conditions] ||= { :title => true, :tags => true }
      params[:query] = params[:query].downcase + '%' unless params[:query].blank?
      params[:limit] ||= 24
    end
    
    def set_format
      request.accepts.unshift Mime::Type.lookup('text/javascript') if params[:respond_to_parent]
    end
  
    def created_notice
      @assets.size ? "'#{CGI.escapeHTML @assets.first.title}' was uploaded." : "#{@assets.size} assets were uploaded."
    end

    def search_options
      return @search_options if @search_options
      
      @search_options = returning :conditions => [] do |options|
        options[:include] = []
        unless params[:query].blank?
          if params[:conditions].has_key?(:title)
            options[:conditions] << Asset.send(:sanitize_sql, ['(LOWER(assets.title) LIKE :query or LOWER(assets.filename) LIKE :query)', {:query => params[:query]}])
          end            
          if params[:conditions].has_key?(:tags)
            options[:include] << :tags
            options[:conditions] << Asset.send(:sanitize_sql, ["(taggings.taggable_type = 'Asset' and tags.name IN (?))", TagList.from(params[:query].chomp("%"))])
          end
        end        
        options[:conditions].blank? ? options.delete(:conditions) : options[:conditions] *= ' OR '
        options.delete(:include) if options[:include].empty?
      end
    end
    
    def count_by_conditions
      type_conditions = @types.blank? ? nil : Asset.types_to_conditions(@types.dup).join(" OR ")
      @count_by_conditions ||= search_options[:conditions].blank? ? site.assets.count(:all, :conditions => type_conditions) :
        Asset.count(:joins => search_options[:joins], 
                    :conditions => "site_id = #{site.id} #{type_conditions && "and #{type_conditions}"} AND #{search_options[:conditions]}", 
                    :include => search_options[:include])
    end
    
    def allow_member?
      @asset && @asset.user_id.to_s == current_user.id.to_s
    end
end
