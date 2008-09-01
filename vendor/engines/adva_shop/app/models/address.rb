class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true
  validates_presence_of :full_name, :street1, :city, :state, :country, :zip_code
end

