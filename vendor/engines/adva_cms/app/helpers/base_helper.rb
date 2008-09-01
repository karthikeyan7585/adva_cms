class ActionView::Base
  unless method_defined? :method_missing_with_returning_paths
    def method_missing_with_returning_paths(name, *args)
      name = name.to_s
      if name.sub!(/_returning(_path|_url)$/, '')
        options = args.extract_options!
        options.reverse_merge! :return_to => params[:return_to] || request.request_uri
        args << options
        send :"#{name}#{$1}", *args
      else
        method_missing_without_returning_paths name.to_sym, *args
      end    
    end
    alias_method_chain :method_missing, :returning_paths 
  end
end

module BaseHelper
  def link_to_section_main_action
    case @section
    when Wiki
      link_to 'Wikipages', admin_wikipages_path(@site, @section)
    when Shop                                                   
      link_to 'Products', admin_products_path(@site, @section)  
    when Section, Blog
      link_to 'Articles', admin_articles_path(@site, @section)
    end
  end  
  
  # does exactly the same as the form_for helper does, but splits off the
  # form head tag and captures it to the content_for :form collector
  def split_form_for(*args, &block)
    buffer = eval(ActionView::Base.erb_variable, block.binding)
    out = capture_erb_with_buffer(buffer, *args) { form_for(*args, &block) }

    lines = out.split("\n")
    content_for :form, lines.shift
    lines.pop

    concat lines.join("\n"), block.binding
  end  
  
  # same as Rails text helper, but returns only the pluralized string without 
  # the number botched into it  
  def pluralize_str(count, singular, plural = nil)
    str = if count.to_i == 1
      singular
    elsif plural
      plural
    elsif Object.const_defined?("Inflector")
      Inflector.pluralize(singular)
    else
      singular + "s"
    end
    str % count.to_i
  end
  
  def todays_short_date
    Time.zone.now.to_ordinalized_s(:stub)
  end
 
  def yesterdays_short_date
    Time.zone.now.yesterday.to_ordinalized_s(:stub)
  end
  
  def filter_options
    FilteredColumn.filters.keys.inject([]) do |arr, key| 
      arr << [FilteredColumn.filters[key].filter_name, key.to_s]
    end.unshift ['Plain HTML', '']
  end
  
end