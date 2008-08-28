class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses, :force => true do |t|
      t.string        :full_name
      t.string        :street1
      t.string        :street2
      t.string        :city
      t.string        :state
      t.string        :country
      t.string        :zip_code
      t.string        :phone
      t.references    :user
      t.string        :email
    end
  end

  def self.down
    drop_table :addresses
  end
end
