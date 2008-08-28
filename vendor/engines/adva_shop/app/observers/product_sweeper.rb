class ProductSweeper < PageCacheTagging::Sweeper
  observe Product
  
  def before_save(product)
    if product.new_record?
      expire_cached_pages_by_reference product.section
    else
      expire_cached_pages_by_reference product
    end
  end
  
  alias after_destroy before_save
end