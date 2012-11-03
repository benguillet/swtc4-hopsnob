# == Schema Information
#
# Table name: liquor_stores
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  address      :text
#  city         :string(255)
#  state        :string(255)
#  zip_code     :integer
#  latitude     :decimal(, )
#  longitude    :decimal(, )
#  phone_number :string(255)
#  email        :string(255)
#  website      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LiquorStore < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :products
end
