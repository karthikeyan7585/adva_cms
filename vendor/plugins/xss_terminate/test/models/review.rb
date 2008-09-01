class Review < ActiveRecord::Base
  belongs_to :person
  
  xss_terminate :html5lib_sanitize => [:body, :extended]
end
