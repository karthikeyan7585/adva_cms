module Stubby
  mattr_accessor :base_definitions, :instance_definitions
  @@base_definitions = {}
  @@instance_definitions = {}
  
  class << self
    def included(base)
      base.after :each do Stubby::Instances.clear! end    
    end

    def base_definition(name)
      name = name.name.demodulize if name.is_a? Class
      @@base_definitions[name]
    end

    def instance_definitions(name)
      @@instance_definitions[name] ||= {}
    end   
  end
  
  class Definition
    cattr_accessor :directory

    attr_reader :name, :class, :original_class, :base_class, :methods
    attr_accessor :default_instance_key
    
    def initialize(attributes = {})
      attributes.each{|name, value| instance_variable_set :"@#{name}", value }
      register
    end
    
    def register
      if base_class == Stub
        Stubby.base_definitions[key] = self
      else
        base_definition.default_instance_key ||= instance_key
        Stubby.instance_definitions(base_key)[instance_key] = self
      end
    end
    
    def name
      @name ||= original_class.name if original_class
      @name
    end
    
    def base_class
      @base_class ||= Stub
    end
    
    def base_key
      @base_key ||= base_class.name.demodulize
    end
    
    def base_definition
      @base_definition ||= Stubby.base_definitions[base_key]
    end

    def instance_definitions
      Stubby.instance_definitions(key)
    end
    
    def instance_definition(instance_key)
      Stubby.instance_definitions(key)[instance_key]
    end
    
    def key
      @key ||= name.to_s.classify.sub('::', '')
    end
    
    def instance_key
      @instance_key ||= name.demodulize.underscore.to_sym
    end
    
    def original_class
      @original_class ||= base_class.original_class if base_class
      @original_class
    end
    
    def methods
      @methods ||= {}
    end
    
    def create!(&block)
      @class = ClassFactory.create(base_class, name, original_class, methods, &block)
    end
      
    def instantiate(key = nil)
      if key == :all
        instance_definitions.collect{|key, definition| definition.instantiate }
      elsif key
        key = default_instance_key if key == :first
        instance_definition(key).instantiate
      else
        Instances.by_key(base_class)[instance_key] or
        Instances.store(base_class, self.class.new, instance_key)
      end
    end
    
    module Loader
      class << self
        def define(original_class, &block)
          definition = Definition.new :original_class => original_class
          definition.create! &block
        end
    
        def instance(klass, *args)
          klass = Stubby.base_definition(klass).class
          definition = Definition.new :base_class => klass, 
                                      :methods => args.extract_options!, 
                                      :name => args.shift.to_s.camelize
          definition.create!                            
        end        
    
        def load
          unless @loaded
            Dir["#{Stubby::Definition.directory}/**/*.rb"].each do |filename|
              instance_eval IO.read(filename), filename
            end
          end
          @loaded = true
        end 
      end
    end
  end  
end