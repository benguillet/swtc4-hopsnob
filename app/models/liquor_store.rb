class LiquorStore < ActiveRecord::Base
  attr_accessible :address, :city, :email, :name, :phone_number, :state, :website, :zip_code
end
