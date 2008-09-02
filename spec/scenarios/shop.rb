scenario :shop do
  scenario :empty_site
  @shop = stub_shop
  Section.stub!(:find).and_return @section
  @site.sections.stub!(:root).and_return @section
end

