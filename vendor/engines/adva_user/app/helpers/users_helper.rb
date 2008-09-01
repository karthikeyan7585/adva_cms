module UsersHelper
  # Includes a javascript tag that will load a javascript snippet
  # generated by the RolesController. This snippet will contain roles data
  # for the current user and toggle visibility for authorized elements.
  def authorize_elements(object = nil)
    object_path = object ? "/#{object.class.name.downcase.pluralize}/#{object.id}" : ''
    javascript_tag <<-js
      var uid = Cookie.get('uid');
      if(uid) {
        new Ajax.Request('/users/' + uid + '/roles#{object_path}.js', { 
          method: 'get', asynchronous: false, evalScripts: true, 
        })
      }
      var aid = Cookie.get('aid');
      if(aid) {
        Event.onReady(function() {
          var roles = new Array('anonymous-' + aid);
          authorize_elements(roles);
        });
        // new Ajax.Request('/anonymouses/' + aid + '.js', { 
        //   method: 'get', asynchronous: false, evalScripts: true, 
        // })
      }
    js
  end
  
  def authorized_tag(name, action, object, options = {}, &block)
    add_authorizing_css_classes! options, action, object
    content_tag name, options, &block
  end
  
  def authorized_link_to(text, url, action, object, options = {})
    add_authorizing_css_classes! options, action, object
    link_to text, url, options
  end
  
  # Adds the css class required-roles as well as a couple of css classes that
  # can be matched with the current user's roles in order to toggle the visibility
  # of an element
  def add_authorizing_css_classes!(options, action, object)
    roles = object.role_authorizing(action).expand
    
    options[:class] ||= ''
    options[:class] = options[:class].split(/ /)
    options[:class] << 'visible-for' << roles.map(&:to_css_class).join(' ')
    options[:class] = options[:class].flatten.uniq.join(' ')
  end
  
  def authorizing_css_classes(roles, options = {})
    separator = options[:separator] || ''
    roles.map(&:to_css_class).map{|role| options[:quote] ? "'#{role}'" : role }.join(separator)
  end
  
  def who(name)
    name = name.name if name.is_a? User
    return current_user && current_user.name == name ? "You" : name
  end

  def gravatar_img(user, options = {})
    image_tag gravatar_url(user.email), {:class => 'avatar'}.merge(options)
  end
  
  def gravatar_url(email = nil, size = 80)
    default = 'avatar.gif'
    return default if email.blank?
    require 'digest/md5'
    digest = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar.php?size=#{size}&gravatar_id=#{digest}&default=http://#{request.host_with_port}#{ActionController::AbstractRequest.relative_url_root}/images/avatar.gif"
  end
end