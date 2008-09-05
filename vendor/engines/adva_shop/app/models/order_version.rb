class OrderVersion < ActiveRecord::Base
  belongs_to :order
  acts_as_nested_set
  attr_accessor :siblings
    
   class << self
    def find_coinciding_grouped_by_dates(*dates)
      options = dates.extract_options!
      groups = (1..dates.size).collect{[]}
      order_versions = find_coinciding({:order => 'order_versions.updated_at DESC', :limit => 50}.update(options)) #, :include => :user
      # collect order_versions for the given dates
      order_versions.each do |order_version|
        order_version_date = order_version.updated_at.to_date
        dates.each_with_index {|date, i| groups[i] << order_version and break if order_version_date == date }
      end
      
      # remove all found order_versions from the original resultset
      groups.each{|group| group.each{ |order_version| order_versions.delete(order_version) }}
      
      # push remaining resultset as a group itself (i.e. 'the rest of them')
      groups << order_versions
  end
  
  def find_coinciding(options = {})
      delta = options.delete(:delta)
      order_versions = find(:all, options).group_by{|r| "#{r.status}"}.values
      order_versions = group_coninciding(order_versions, delta)
      order_versions.sort{|a, b| b.updated_at <=> a.updated_at }
  end
    
  def group_coninciding(order_versions, delta = nil)
      order_versions.inject [] do |chunks, group|
        chunks << group.shift
        group.each do |order_version|
          last = chunks.last.siblings.last || chunks.last
          if last.coincides_with?(order_version, delta) 
            chunks.last.siblings << order_version
        else
            chunks << order_version
          end
        end
        chunks
      end
  end
end  

def after_initialize
    @siblings = []
  end

def coincides_with?(other, delta = nil)
    delta ||= 1.hour
    created_at - other.updated_at <= delta.to_i 
  end
end