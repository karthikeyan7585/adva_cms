Section.delete_all

factories :site, :sections

factory :shop, valid_section_attributes.update(:type => 'Shop', :title => 'shop'),
        :class => :section
