class Admin::ProductsController < Admin::BaseController

  layout "admin"
  helper :assets
  
  before_filter :set_section
  before_filter :set_product,      :only => [:show, :edit, :update, :destroy, :product_image]
  before_filter :set_categories,   :only => [:new, :edit]
  
  widget :section_tree, :partial => 'widgets/admin/section_tree',
                        :only    => { :controller => ['admin/products'] }
  
  widget :menu_section, :partial => 'widgets/admin/menu_section',
                        :only  => { :controller => ['admin/products'] }
    
  cache_sweeper :product_sweeper, :category_sweeper, :tag_sweeper, 
                :only => [:create, :update, :destroy]
  
  # Find the products of the shop and list them with pagination
  def index
    add_to_sortable_columns('name', { :model => Product, :field => 'name', :alias => 'name' })
    options = {:page => current_page, :per_page => 3, :order => sortable_order('name', :model => Product, 
                                                                                        :field => 'name', 
                                                                                        :sort_direction => :desc)}
    @products = @section.products.paginate options.reverse_merge(filter_options)
    template = @section.type == 'Section' ? 'admin/products/index' : "admin/#{@section.type.downcase}/index"
    render :template => template
  end
  
  def show
    render @section.render_options(:layout => 'default').merge(:template => "#{@section.type.downcase}/show")
  end
  
  # Create a new product instance for the shop
  def new
    @product = @section.products.build :comment_age => @section.comment_age, :filter => @section.content_filter
  end
  
  # Find the selected product and render product edit page
  def edit
  end
  
  # Create a new product for the shop
  def create
    @product = @section.products.build(params[:product])
    
    # Save the product image
    set_graphic_image
    
    # Save the product
    if @product.save
      flash[:notice] = "The product has been created"
      redirect_to admin_products_path
    else
      set_categories
      flash.now[:error] = "The product could not be created"
      render :action => 'new'
    end
  end
  
  # Update the product details
  def update
    @product.attributes = params[:product]
    
    # Update the product image
    set_graphic_image
    
    # Save the product details
    if @product.save
      flash[:notice] = "The product has been updated"
      redirect_to admin_products_path
    else
      set_categories
      flash.now[:error] = "The product could not be updated"
      render :action => 'edit'
    end
  end
  
  # Remove the product from the shop
  def destroy
    if @product.destroy
      flash[:notice] = "The product has been removed"
      redirect_to admin_products_path
    else
      set_categories
      flash.now[:error] = "The product could not be removed"
      render :action => 'edit'
    end
  end
  
  private
    
    # Set the section
    def set_section
      @section = @site.sections.find(params[:section_id])
    end
    
    # Set the product
    def set_product
      @product = @section.products.find(params[:id])
    end
    
    # Set the categories
    def set_categories
      @categories = @section.categories.roots
    end
    
    # Set the product image if the admin has selected any image for the product
    def set_graphic_image
      unless params[:product_image].blank? or params[:product_image][:uploaded_image].blank?
        @product.product_image = ProductImage.new(:uploaded_data => params[:product_image][:uploaded_image])  
      end
    end
    
    # Set the filter options
    def filter_options
      options = {}
      case params[:filter]
        when 'category'
        options[:joins] = "#{options[:joins]} INNER JOIN product_categories ON products.id = product_categories.product_id"
        condition = Product.send(:sanitize_sql, ['product_categories.category_id = ?', params[:category].to_i])
        options[:conditions] = options[:conditions] ? "(#{options[:conditions]}) AND (#{condition})" : condition
        when 'name'
        options[:conditions] = Product.send(:sanitize_sql, ["LOWER(products.name) LIKE ?", "%#{params[:query].downcase}%"])
        when 'description'
          options[:conditions] = Product.send(:sanitize_sql, ["LOWER(products.description) LIKE ?", "%#{params[:query].downcase}%"])
        when 'tags'
          tags = TagList.new(params[:query], :parse => true)
          options[:joins] = "INNER JOIN taggings ON taggings.taggable_id = products.id and taggings.taggable_type = 'Product' INNER JOIN tags on taggings.tag_id = tags.id"
          options[:conditions] = Product.send(:sanitize_sql, ["tags.name IN (?)", tags])
      end
      options
    end  
end