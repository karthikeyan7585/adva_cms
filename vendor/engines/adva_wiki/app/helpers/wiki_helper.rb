module WikiHelper
  class << self
    def included(base)
      [ActionController::Base, ActionView::Base].each do |target|
        return if target.method_defined? :wikipage_path_with_home
        [:path, :url].each do |kind|
          target.class_eval <<-CODE        
            alias :wikipage_#{kind}_with_home :wikipage_#{kind}
            def wikipage_#{kind}(*args)
              returning wikipage_#{kind}_with_home(*args) do |url|
                url.sub! %r(/pages/home$), ''
              end
            end
          CODE
        end
      end
    end
  end
  
  def wikify(str)
    redcloth = RedCloth.new(str)
    redcloth.gsub!(/\[\[(.*?)\]\]/u){ wikify_link($1) }
    auto_link redcloth.to_html
  end
    
  def wikify_link(str)
    permalink = PermalinkFu.escape(str)
    options = {}
    options[:class] = "new_wiki_link" unless Wikipage.find_by_permalink(permalink)
    link_to str, wikipage_path(@section, permalink), options
  end
    
  # def wikify_link(str)
  #   permalink = PermalinkFu.escape(str)
  #   if wikipage = Wikipage.find_by_permalink(permalink)
  #     link_to str, wikipage.home? ? wiki_path(@section) : wikipage_path(@section, permalink)
  #   else
  #     link_to str, wikipage_path(@section, permalink), :class => "new_wiki_link" 
  #   end
  # end
  
  def wiki_edit_links(wikipage, options = {})
    separator = options[:separator] || '' # || ' &middot; '
    
	  links = []
	  links << content_tag(:li, options[:prepend]) if options[:prepend]
	  links << content_tag(:li) do
	    link_to('return to home', wiki_path(@section))
    end unless wikipage.home?
    
	  if wikipage.version == wikipage.versions.last.version
	    links << authorized_tag(:li, :update, wikipage) do
	      link_to('edit this page', edit_wikipage_path(@section, wikipage.permalink))
      end
	    links << authorized_tag(:li, :destroy, wikipage) do
	      link_to('delete this page', wikipage_path(@section, wikipage.permalink), { :confirm => "Are you sure you wish to delete this page?", :method => :delete })
      end unless wikipage.home?
    else
	    links << authorized_tag(:li, :update, wikipage) do
	      link_to('rollback to this revision', wikipage_path_with_home(@section, wikipage.permalink, :version => wikipage.version), { :confirm => "Are you sure you wish to rollback to this version?", :method => :put })
      end
    end

    if wikipage.versions.size > 1
      if wikipage.version > wikipage.versions.first.version
  	    links << content_tag(:li) do
  	      link_to('view previous revision', wikipage_rev_path(:section_id => @section.id, :id => wikipage.permalink, :version => (wikipage.version - 1)))
	      end
      end
      if wikipage.version < wikipage.versions.last.version - 1
  	    links << content_tag(:li) do
  	      link_to('view next revision', wikipage_rev_path(:section_id => @section.id, :id => wikipage.permalink, :version => (wikipage.version + 1)))
	      end
	    end
      if wikipage.version < wikipage.versions.last.version
  	    links << content_tag(:li) do
  	      link_to('return to current revision', wikipage_path(@section, wikipage.permalink))
	      end
      end
    end
    
	  links << content_tag(:li, options[:append]) if options[:append]
    
    content_tag :ul, links * "\n", :class => 'links'
  end
  
end