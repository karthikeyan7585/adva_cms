class Product < ActiveRecord::Base
  
  class Jail < Safemode::Jail
    allow :section, :categories, :tags, :approved_comments, :accept_comments?, :comments_count
  end

  acts_as_taggable
  has_many_comments :as => :commentable, :polymorphic => true

  belongs_to :section
  belongs_to :site
  
  has_permalink :name, :scope => :section_id
  
  has_many :categories, :through => :product_categories
  has_many :product_categories, :dependent => :destroy
  has_one :product_image, :dependent => :destroy
  
  delegate :comment_filter, :to => :site
  delegate :accept_comments?, :to => :section
  
  before_validation :set_site
  
  #DEVNOTE - Why should we have this in class attribute. We can put it in the array or hash right?
  class_inheritable_reader :default_find_options
  write_inheritable_attribute :default_find_options, {:order => 'name'}
  
  validates_presence_of :name, :description
  validates_numericality_of :price, :message => "can only be a number"
  validates_numericality_of :weight, :tax_rate, :allow_nil => true, :message => "can only be a number"
  validates_numericality_of :quantity, :allow_nil => true, :only_integer => true, :message => "can only be a whole number"
  validates_uniqueness_of :permalink, :scope => :section_id
  
 class << self
    def find_every(options)
      options = default_find_options.merge(options)    
      if tags = options.delete(:tags)
        options = find_options_for_find_tagged_with(tags, options.update(:match_all => true))
      end
      super options
    end
    
    def find_with_tags(*args)
      options = args.extract_options!
      with_tags *args do find(:all, options) end
    end
    
    def with_tags(*args, &block)
      return yield if args.compact.empty?
      with_scope({:find => {:conditions => {}}}, &block)
    end
  end
  
  def accept_comments?
    comment_age > -1
  end
  
  private
  
  def set_site
    self.site_id = section.site_id if section
  end

end