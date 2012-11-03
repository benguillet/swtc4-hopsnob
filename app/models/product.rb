# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  price           :decimal(, )
#  number_of_items :integer
#  item_volume     :decimal(, )
#  item_type       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Product < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :beers
  has_and_belongs_to_many :liquor_stores
end
