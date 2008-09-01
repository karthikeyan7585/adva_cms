class Admin::AssetContentsController < Admin::BaseController
  layout false
  
  before_filter :set_asset, :set_content
  helper :assets
  
  def create
    @asset.contents << @content
    @asset.save
  end

  def destroy
    @asset.contents.delete @content
    @asset.save
  end
  
  private
  
    def set_asset
      @asset = @site.assets.find params[:asset_id]
    end
  
    def set_content
      key = params[:action] == 'create' ? :content_id : :id
      @content = ::Content.find params[key], :include => 'section'
      raise "no access" if @content.section.site_id != @site.id
    end
  
end